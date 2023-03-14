
import argparse

import pandas as pd
import torch
import wandb
import random

import torch.nn as nn
import numpy as np

from torchvision import transforms, datasets
from model import PlantClassificationNet


# fix seed so that different runs are comparable
np.random.seed(1)
torch.manual_seed(1)
random.seed(1)

DEVICE = torch.device("cuda:0")


def evaluate(model, test_loader, criterion):
    """
    Evaluates the given model; calculates loss and accuracy on a validation/testing set.

    :param model: (torch.nn.Module) model to evaluate
    :param test_loader: (torch.utils.data.DataLoader) testing set
    :param criterion: (torch.nn.*Loss) module that calculates the loss function

    :return: (float, float) loss, accuracy
    """

    # ensure that weights are fixed
    model.eval()

    with torch.no_grad():

        total_loss, total_sample, total_correct = 0, 0, 0

        for image, label in test_loader:
            # move data to GPU to match the model device
            image = image.to(DEVICE)
            label = label.to(DEVICE)

            # infer (obtain prediction) for one step (may include multiple items, guided by the args.batch_size)
            output = model(image)
            loss = criterion(output, label)

            total_loss += loss.item()
            total_sample += len(label)
            total_correct += torch.sum(torch.max(output, 1)[1] == label).item() * 1.0

    return total_loss / total_sample, total_correct / total_sample


def train(model, train_loader, test_loader, criterion, optimizer):
    """
    Trains the given model for args.epochs — encompasses the full training loop according to global run parameters.

    :param model: (torch.nn.Module) model to train
    :param train_loader: (torch.utils.data.DataLoader) training set, augmentations included
    :param test_loader: (torch.utils.data.DataLoader) testing set
    :param criterion: (torch.nn.*Loss) module that calculates the loss function
    :param optimizer: (torch.optim.*) optimizer for guiding backpropagation

    :return: (torch.nn.Module, pd.DataFrame) tuple with the trained model and run statistics dataframe
    """

    augmentations = construct_augmentation_transforms()
    statistics = pd.DataFrame(columns=["train_loss", "train_acc", "validation_loss", "validation_acc"])

    for i in range(args.epochs):
        # ensure that weights may be manipulated
        model.train()

        total_loss, total_sample, total_correct = 0, 0, 0

        for image, label in train_loader:
            # apply augmentations, move data to GPU to match the model device
            image = augmentations(image).to(DEVICE)
            label = label.to(DEVICE)

            # train one step (may include multiple items, guided by the args.batch_size)
            output = model(image)
            loss = criterion(output, label)

            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

            total_loss += loss
            total_sample += len(label)
            total_correct += torch.sum(torch.max(output, 1)[1] == label) * 1.0

        loss = total_loss / total_sample
        acc = total_correct / total_sample

        val_loss, val_acc = evaluate(model, test_loader, criterion)

        wandb.log({"train_loss": loss, "train_acc": acc, "validation_loss": val_loss, "validation_acc": val_acc}, step=i)
        statistics = statistics.append({
            "train_loss": loss.cpu().detach(),
            "train_acc": acc.cpu(),
            "validation_loss": val_loss,
            "validation_acc": val_acc}, ignore_index=True)
        print(f"epoch {i} loss:{total_loss / total_sample}  acc:{total_correct / total_sample}")

    return model, statistics


def construct_preprocessing_transforms():
    """
    Constructs a composed set of pre-processing operations.

    :return: (torchvision.transforms.transforms.Compose) sequence of operations
    """

    transforms_components = [
        transforms.Resize(150),
        transforms.ToTensor(),
        transforms.Normalize([0.5, 0.5, 0.5], [0.5, 0.5, 0.5])
    ]

    return transforms.Compose(transforms_components)


def construct_augmentation_transforms():
    """
    Constructs a composed set of augmentations based on the global parameters, most notably
    args.transforms_color_jitter, args.transforms_random_crop, args.transforms_rotation, args.rotation_deg,
    args.crop_min_pix, args.brightness_range, args.saturation_range, args.hue_range.

    :return: (torchvision.transforms.transforms.Compose) sequence of operations
    """

    transforms_components = []

    # color jitter augmentations: brightness, saturation, and hue
    if args.transforms_color_jitter:
        transforms_components.append(transforms.ColorJitter(brightness=(1 - args.brightness_range,
                                                                        1 + args.brightness_range), contrast=(1),
                                                            saturation=(1 - args.saturation_range,
                                                                        1 + args.saturation_range),
                                                            hue=(0 - args.hue_range, 0 + args.hue_range)))

    # random crop augmentation
    if args.transforms_random_crop:
        transforms_components.append(transforms.RandomCrop(size=(150 - args.crop_min_pix, 150 - args.crop_min_pix)))
        transforms_components.append(transforms.Resize(150))

    # random rotation augmentation
    if args.transforms_rotation:
        transforms_components.append(transforms.RandomRotation(degrees=args.rotation_deg))

    return transforms.Compose(transforms_components)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Parameters")

    # parameters: data
    parser.add_argument("--dataset-path", dest="dataset_path", type=str,
                        default="/home/azureuser/localfiles/PlantVillage-Dataset/", help="path to the PlantVillage "
                        "dataset, unzipped and structured in the default class-corresponding folder scheme")

    # parameters: training loop
    parser.add_argument("--epochs", type=int, default=20, help="number of epochs to train for")
    parser.add_argument("--batch-size", dest="batch_size", type=int, default=32, help="number of training items to "
                        "batch during the training loop, constrainted by your GPU’s memory")
    parser.add_argument("--learning-rate", dest="lr", type=float, default=0.01, help="learning rate parameter passed "
                        "onto the selected optimizing algorithm (Adam)")

    # parameters: model
    parser.add_argument("--kernel_size", type=int, default=4, help="model's kernel size")
    parser.add_argument("--dense", type=int, default=512, help="model's dense layer size")
    parser.add_argument("--feature-map-size", dest="feature_map_size", type=int, default=16, help="model's feature map"
                        " size")

    # parameters: augmentation flags
    parser.add_argument("--transforms-color-jitter", dest="transforms_color_jitter", action="store_true",
                        help="indicator of whether to use the color jitter augmentations")
    parser.add_argument("--transforms-random-crop", dest="transforms_random_crop", action="store_true",
                        help="indicator of whether to use the random crop augmentations")
    parser.add_argument("--transforms-rotation", dest="transforms_rotation", action="store_true",
                        help="indicator of whether to use the rotation augmentations")

    # parameters: augmentation cap hyperparameters
    parser.add_argument("--rotation-deg", dest="rotation_deg", type=int, default=15, help="maximum degrees to rotate "
                        "using the rotate augmentation")
    parser.add_argument("--crop-min-pix", dest="crop_min_pix", type=int, default=15, help="number of pixels to subtract"
                        " in both height and width for the random crop augmentation window")
    parser.add_argument("--brightness-range", dest="brightness_range", type=float, default=0.5, help="maximum relative "
                        "change in brightness to use with the brightness augmentation")
    parser.add_argument("--saturation-range", dest="saturation_range", type=float, default=0.5, help="maximum relative "
                        "change in saturation to use with the saturation augmentation")
    parser.add_argument("--hue-range", dest="hue_range", type=float, default=0.1, help="maximum relative change in hue "
                        "to use with the hue augmentation")

    # parameters: weights & biases
    parser.add_argument("--project-name", dest="project_name", type=str, default="maturita--plant-identification-NEW")
    parser.add_argument("--wandb-key", dest="wandb_key", type=str, default="beb8925bb5b17aaecd40139da4c299f76753291e",
                        help="")

    # init wandb run for experiment tracking
    args = parser.parse_args()
    wandb.login(key=args.wandb_key)

    # the data is split as 80-20 train-val (which is considered standard)
    plant_village_dataset = datasets.ImageFolder(args.dataset_path, transform=construct_preprocessing_transforms())
    train_set, val_set = torch.utils.data.random_split(plant_village_dataset, [int(0.8 * len(plant_village_dataset)),
                                                                               int(0.2 * len(plant_village_dataset))])

    run = wandb.init(project=args.project_name, entity="matyasbohacek", config={
        "kernel-size": args.kernel_size,
        "epochs": args.epochs,
        "dense": args.dense,
        "feature-maps": [args.feature_map_size, args.feature_map_size],
        "batch-size": args.batch_size,
        "learning_rate": args.lr,
        "transforms-color-jitter": args.transforms_color_jitter,
        "transforms-random-crop": args.transforms_random_crop,
        "transforms-rotation": args.transforms_rotation,
        "rotation-deg": args.rotation_deg,
        "crop-min-pix": args.crop_min_pix,
        "brightness-range": args.brightness_range,
        "saturation-range": args.saturation_range,
        "hue-range": args.hue_range
    })

    plant_classification_net = PlantClassificationNet(kernel_size=args.kernel_size,
                                                      feature_maps=[args.feature_map_size, args.feature_map_size],
                                                      dense=args.dense)
    plant_classification_net = plant_classification_net.to(DEVICE)

    plant_train_loader = torch.utils.data.DataLoader(train_set, batch_size=args.batch_size, shuffle=True)
    plant_test_loader = torch.utils.data.DataLoader(val_set, shuffle=True)

    criterion_cel = nn.CrossEntropyLoss()
    optimizer_sgd = torch.optim.SGD(plant_classification_net.parameters(), lr=args.lr)

    plant_classification_net, run_statistics = train(plant_classification_net, plant_train_loader, plant_test_loader,
                                                     criterion_cel, optimizer_sgd)

    wandb.watch(plant_classification_net, criterion_cel, log="all", log_freq=10)

    torch.save(plant_classification_net.state_dict(), "model.pt")
    wandb.save("model.pt")

    print(run_statistics)

    run.summary["top-validation-accuracy"] = run_statistics["validation_acc"].max()
    run.summary["top-train-accuracy"] = run_statistics["train_acc"].max()

    run.finish()
