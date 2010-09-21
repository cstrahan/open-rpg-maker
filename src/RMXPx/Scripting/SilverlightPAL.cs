using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Browser;
using Microsoft.Scripting;
using Microsoft.Scripting.Silverlight;

namespace RMXPx.Scripting
{
    // A pimped out PAL.
    // Looks for files with the following precedence:
    // 1) Files marked as 'Content'  (within XAP)
    // 2) Files marked as 'Resource' (within assemblies)
    // 3) Files on the webserver (relative to the hosting page)
    public class SilverlightPAL : PlatformAdaptationLayer
    {
        private PlatformAdaptationLayer _httpPAL = BrowserPAL.Default;
        public XapVirtualFilesystem XapFileSystem { get; private set; }

        public SilverlightPAL()
        {
             XapFileSystem = new XapVirtualFilesystem();
        }

        public override Assembly LoadAssembly(string name)
        {
            return Default.LoadAssembly(name);
        }

        public override Assembly LoadAssemblyFromPath(string path)
        {
            throw new NotImplementedException();
        }

        public override void TerminateScriptExecution(int exitCode)
        {
            throw new NotImplementedException();
        }

        public override bool FileExists(string path)
        {
            return XapFileSystem.FileExists(path);
        }

        public override bool DirectoryExists(string path)
        {
            return XapFileSystem.DirectoryExists(path);
        }

        public override Stream OpenInputFileStream(string path, FileMode mode, FileAccess access, FileShare share)
        {
            return XapFileSystem.OpenInputFileStream(path);
        }

        public override Stream OpenInputFileStream(string path, FileMode mode, FileAccess access, FileShare share, int bufferSize)
        {
            return XapFileSystem.OpenInputFileStream(path);
        }

        public override Stream OpenInputFileStream(string path)
        {
            return XapFileSystem.OpenInputFileStream(path);
        }

        public override Stream OpenOutputFileStream(string path)
        {
            throw new NotImplementedException();
        }

        public override void DeleteFile(string path, bool deleteReadOnly)
        {
            throw new NotImplementedException();
        }

        public override string[] GetFileSystemEntries(string path, string searchPattern, bool includeFiles, bool includeDirectories)
        {
            return XapFileSystem.GetFileSystemEntries(path, searchPattern, includeFiles, includeDirectories);
        }

        public override string GetFullPath(string path)
        {
           return XapFileSystem.GetFullPath(path);
        }

        public override string CombinePaths(string path1, string path2)
        {
            throw new NotImplementedException();
        }

        public override string GetFileName(string path)
        {
            throw new NotImplementedException();
        }

        public override string GetDirectoryName(string path)
        {
            throw new NotImplementedException();
        }

        public override string GetExtension(string path)
        {
            throw new NotImplementedException();
        }

        public override string GetFileNameWithoutExtension(string path)
        {
            throw new NotImplementedException();
        }

        public override bool IsAbsolutePath(string path)
        {
            return path.Length > 0 && (path[0] == '/' || path[0] == '\\');
        }

        public override void CreateDirectory(string path)
        {
            throw new NotImplementedException();
        }

        public override void DeleteDirectory(string path, bool recursive)
        {
            throw new NotImplementedException();
        }

        public override void MoveFileSystemEntry(string sourcePath, string destinationPath)
        {
            throw new NotImplementedException();
        }

        public override string GetEnvironmentVariable(string key)
        {
            throw new NotImplementedException();
        }

        public override void SetEnvironmentVariable(string key, string value)
        {
            throw new NotImplementedException();
        }

        public override IDictionary GetEnvironmentVariables()
        {
            throw new NotImplementedException();
        }

        public override StringComparer PathComparer
        {
            get { return StringComparer.OrdinalIgnoreCase; }
        }

        public override string CurrentDirectory
        {
            get { return XapFileSystem.CurrentDirectory; }
            set { XapFileSystem.CurrentDirectory = value; }
        }
    }
}