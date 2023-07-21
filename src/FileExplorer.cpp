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

void FileExplorer::openFileExplorer() {
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
        filePath = selectedFilePath;
        size_t lastSeparator = filePath.find_last_of("\\/");
        fileName = filePath.substr(lastSeparator + 1);
    }
    else {
        DWORD error = CommDlgExtendedError();
        if (error != 0)
            std::cerr << "Error: " << error << std::endl;
        else
            std::cout << "No file selected." << std::endl;
    }
    #endif
    
    std::string cmd = "xdg-open \"" + std::string(std::filesystem::current_path()) + "\"";
    system(cmd.c_str());
}

std::string FileExplorer::getFilePath() {
    return filePath;
}

std::string FileExplorer::getFileName() {
    return fileName;
}