#include <iostream>
#include <opencv2/opencv.hpp>
#include <filesystem>

int main (int argc, char** argv) {
    std::string imgFolder = "img";
    std::string fileName = "Chad.png";
    std::filesystem::path currentPath = std::filesystem::current_path();
    std::filesystem::path imgFilePath = currentPath / imgFolder / fileName;
    // Display image

    cv::Mat img;
    img = cv::imread(imgFilePath.generic_string());
    if (!img.data) {
        std::cout << "Failed to load image :( \n";
        return -1;
    }
    cv::namedWindow("Loaded image", cv::WINDOW_AUTOSIZE);
    cv::imshow("Loaded image", img);
    
    while (1) {

    }

    return 0;
}