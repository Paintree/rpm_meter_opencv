#include <string>
#ifdef UNIX
#include <gtk/gtk.h>
#endif

class FileExplorer
{
    public:
        void openFileExplorer(int argc, char *argv[]);
        std::string getFilePath();
        std::string getFileName();
    private:
        std::string _filePath;
        std::string _fileName;
#ifdef UNIX
        void openFileDialog(GtkWidget *widget, gpointer data);
#endif

};

