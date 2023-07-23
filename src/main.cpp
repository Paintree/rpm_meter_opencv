#include <iostream>
#include <opencv2/opencv.hpp>
#include <FileExplorer.hpp>


int main (int argc, char *argv[]) {

    FileExplorer Image;
    Image.openFileExplorer(argc, argv);

    // Load image
    cv::Mat img;
    std::cout << "Loading image...\n";
    img = cv::imread(Image.getFilePath());
    if (!img.data) {
        std::cout << "Failed to load image :( \n";
        return -1;
    }
    std::cout << "Loaded image: " + Image.getFileName() + "\n";
    // Display image
    cv::namedWindow(Image.getFileName(), cv::WINDOW_AUTOSIZE);
    cv::imshow(Image.getFileName(), img);
    cv::waitKey(0);

    return 0;
}