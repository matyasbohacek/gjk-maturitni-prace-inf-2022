
import argparse
import torch

import coremltools as ct

from model import PlantClassificationNet


# hardwired classes of PlantVillage, sorted by alphabetical order, corresponding to the final model softmax index
CLASS_LABELS = ["Apple___Apple_scab", "Apple___Black_rot", "Apple___Cedar_apple_rust", "Apple___healthy",
                "Blueberry___healthy", "Cherry_(including_sour)___Powdery_mildew", "Cherry_(including_sour)___healthy", 
                "Corn_(maize)___Cercospora_leaf_spot Gray_leaf_spot", "Corn_(maize)___Common_rust_", 
                "Corn_(maize)___Northern_Leaf_Blight", "Corn_(maize)___healthy", "Grape___Black_rot", 
                "Grape___Esca_(Black_Measles)", "Grape___Leaf_blight_(Isariopsis_Leaf_Spot)", "Grape___healthy", 
                "Orange___Haunglongbing_(Citrus_greening)", "Peach___Bacterial_spot", "Peach___healthy", 
                "Pepper,_bell___Bacterial_spot", "Pepper,_bell___healthy", "Potato___Early_blight", 
                "Potato___Late_blight", "Potato___healthy", "Raspberry___healthy", "Soybean___healthy", 
                "Squash___Powdery_mildew", "Strawberry___Leaf_scorch", "Strawberry___healthy", 
                "Tomato___Bacterial_spot", "Tomato___Early_blight", "Tomato___Late_blight", "Tomato___Leaf_Mold", 
                "Tomato___Septoria_leaf_spot", "Tomato___Spider_mites Two-spotted_spider_mite", "Tomato___Target_Spot", 
                "Tomato___Tomato_Yellow_Leaf_Curl_Virus", "Tomato___Tomato_mosaic_virus", "Tomato___healthy"]


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Parameters")

    parser.add_argument("--pt-model", dest="pt_model", type=str, default="", help="name of the original, already"
                        " trained PyTorch model to be converted")
    parser.add_argument("--output-model", dest="output_model", type=str, default="", help="name for the newly converted"
                        " model file")

    args = parser.parse_args()

    # ensure that the inputs are valid
    assert args.pt_model.endswith(".pt"), "the name of the input PyTorch model (for conversion) must end with '.pt'"
    assert args.output_model.endswith(".mlpackage"), "the name of the output model must end with '.mlpackage'"

    # load the model
    plant_classification_net = PlantClassificationNet(kernel_size=4, feature_maps=[16, 16], dense=512)
    plant_classification_net.load_state_dict(torch.load(args.pt_model, map_location=torch.device("cpu")))
    plant_classification_net.eval()

    # construct mock inputs and outputs
    example_input = torch.rand(*plant_classification_net.input_size)
    traced_model = torch.jit.trace(plant_classification_net, example_input)
    output = traced_model(example_input)

    # convert and save
    model = ct.convert(traced_model, source="pytorch", convert_to="mlprogram",
                       classifier_config=ct.ClassifierConfig(CLASS_LABELS),
                       inputs=[ct.ImageType(name="image", shape=example_input.shape, scale=2 / 255.0, bias=[-1, -1, -1])])
    model.save(args.output_model)
