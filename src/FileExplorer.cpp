#include <FileExplorer.hpp>
#ifdef WIN32
#include <windows.h>
#include <commdlg.h>
#endif
#ifdef UNIX
#include <cstdlib>
#include <gtk/gtk.h>
#endif
#include <iostream>
#include <filesystem>

void FileExplorer::openFileExplorer(int argc, char *argv[]) {
    #ifdef WIN32
    OPENFILENAME ofn;
    TCHAR szFile[MAX_PATH] = { 0 };

    ZeroMemory(&ofn, sizeof(ofn));
    ofn.lStructSize = sizeof(ofn);
    ofn.lpstrFile = szFile;
    ofn.nMaxFile = sizeof(szFile);
    ofn.lpstrFilter = TEXT("All Files (*.*)\0*.*\0");
    ofn.lpstrTitle = TEXT("Select a File");
    ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST;

    if (GetOpenFileName(&ofn)) {
#ifdef UNICODE
        // If using Unicode, convert TCHAR (wchar_t) to std::wstring
        std::wstring wideFilePath = szFile;
        std::string selectedFilePath(wideFilePath.begin(), wideFilePath.end());
#else
        // If using ANSI/MBCS, convert TCHAR (char) to std::string
        std::string selectedFilePath = szFile;
#endif
        std::cout << "Selected file: " << selectedFilePath << std::endl;
        _filePath = selectedFilePath;
        size_t lastSeparator = _filePath.find_last_of("\\/");
        _fileName = _filePath.substr(lastSeparator + 1);
    }
    else {
        DWORD error = CommDlgExtendedError();
        if (error != 0)
            std::cerr << "Error: " << error << std::endl;
        else
            std::cout << "No file selected." << std::endl;
    }
    #endif

    GtkWidget *window;

    gtk_init(&argc, &argv);

    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    GtkFileChooserAction action = GTK_FILE_CHOOSER_ACTION_OPEN;
    gint res;

    window = gtk_file_chooser_dialog_new("Open File", GTK_WINDOW(window), action, "_Cancel", GTK_RESPONSE_CANCEL, "_Open", GTK_RESPONSE_ACCEPT, NULL);

    res = gtk_dialog_run(GTK_DIALOG(window));
    if (res == GTK_RESPONSE_ACCEPT) {
        char *filepath;
        filepath = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(window));
        _filePath = filepath;
        g_free(filepath);
    }

    gtk_widget_destroy(window);

    std::cout << "Selected file: " << _filePath << std::endl;
    size_t lastSeparator = _filePath.find_last_of("/");
    _fileName = _filePath.substr(lastSeparator + 1);
}

std::string FileExplorer::getFilePath() {
    return _filePath;
}

std::string FileExplorer::getFileName() {
    return _fileName;
}