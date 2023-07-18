#include <string>

class FileExplorer
{
    public:
        void openFileExplorer();
        std::string getFilePath();
        std::string getFileName();
    private:
        std::string filePath;
        std::string fileName;
};

