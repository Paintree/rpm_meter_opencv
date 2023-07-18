#include <FileExplorer.hpp>
#include <windows.h>
#include <commdlg.h>
#include <iostream>

void FileExplorer::openFileExplorer() {
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
}

std::string FileExplorer::getFilePath() {
    return filePath;
}

std::string FileExplorer::getFileName() {
    return fileName;
}