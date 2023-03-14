
import torch
import torch.nn as nn
import torch.nn.functional as F


class PlantClassificationNet(nn.Module):
    """
    Image-classification, convolutional neural network for plant disease recognition.

        ARCHITECTURE:
        (CONV) -> ReLU -> MaxPool -> (CONV) -> ReLU -> MaxPool -> (LINEAR) -> ReLU -> Dropout -> (LINEAR)

    Note that softmax must be conducted outside of this module's inference.
    """

    def __init__(self, kernel_size=4, feature_maps=(16, 32), input_size=(3, 150, 150), dense=512):
        super(PlantClassificationNet, self).__init__()

        self.input_size = (1, *input_size)
        self.conv1 = nn.Conv2d(3, feature_maps[0], kernel_size=kernel_size, stride=1, padding=0)
        self.pool = nn.MaxPool2d(kernel_size=kernel_size, stride=2, padding=0)
        self.conv2 = nn.Conv2d(feature_maps[0], feature_maps[1], kernel_size=kernel_size, stride=1, padding=0)

        self.fc1 = nn.Linear(self.__get_shape(), dense)
        self.fc2 = nn.Linear(dense, 38)
        self.do = nn.Dropout()

    def extract_feat(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = x.reshape(x.shape[0], -1)
        return x

    def forward(self, x):
        x = self.extract_feat(x)
        x = self.do(F.relu(self.fc1(x)))
        x = self.fc2(x)
        return x

    def __get_shape(self):
        x = torch.rand(*self.input_size, requires_grad=False)
        with torch.no_grad():
            x = self.extract_feat(x)
        return x.shape[1]


if __name__ == "__main__":
    pass
