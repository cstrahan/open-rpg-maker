using System;
using System.Diagnostics;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Browser;
using System.Windows.Resources;

namespace RMXPx.Scripting
{
    // Todo: Create a Directory and File type
    // Keep a reference to a "root" directory
    // Directories and Files should have a method to easily test patterns
    // Directories, when given a relative path, should return the file or directory (or null)
    // Directories should have a parent property, files and directories properties
    // Assuming I want to be able to "move" directories/files, I'll need Files to be aware of their original resource URI.
    // Need to implement "GetFullPath" (particularly apply .. rules to absolute paths). Try looking
    // Need to add some methods for diggin into the VFS trees, for stuff like determining where a file came from.
    public class XapVirtualFilesystem
    {
        private IList<Directory> _roots;
        private Uri _mainXapUri;

        private string _currentDirectory;
        public string CurrentDirectory
        {
            get { return _currentDirectory; }
            set
            {
                if ((value ?? "").Trim() != string.Empty)
                {
                    _currentDirectory = GetFullPath(value);
                    if (_currentDirectory == string.Empty) _currentDirectory = "/";
                }
            }
        }

        public event EventHandler<XapContentLoadedEventArgs> XapContentLoaded;

        public XapVirtualFilesystem()
        {
            _roots = new List<Directory>();
            _currentDirectory = "/";
            _mainXapUri = TryGetMainXapUri();
        }

        // Needs to support urls and Content zip files
        public void Load(IList<Uri> zipUris, Action callback)
        {
            var uriIndex = 0;
            var client = new WebClient();
            OpenReadCompletedEventHandler handler = (object sender, OpenReadCompletedEventArgs e) =>
                                            {
                                                Load(zipUris[uriIndex], e.Result);
                                                uriIndex++;
                                                if (uriIndex < zipUris.Count)
                                                {
                                                    client.OpenReadAsync(zipUris[uriIndex]);
                                                }
                                                else
                                                {
                                                    callback();
                                                }
                                            };

            client.OpenReadCompleted += handler;
            client.OpenReadAsync(zipUris[uriIndex]);
        }

        // Possible deadlock within event subscribers...
        // Need to decide what to do when a file already exists from a previously loaded xap.
        private void Load(Uri xapUri, Stream stream)
        {
            var filePaths = XapInspector.GetFileNames(stream);
            //if (xapUri == _mainXapUri)
            //{
            //    stream.Dispose();
            //    stream = null;
            //}

            foreach (var filePath in filePaths)
            {
                var filePathParts = ("/" + filePath).Split('/');

                var rootName = filePathParts[0];

                Directory directory;
                lock (_roots)
                {
                    directory =
                        _roots.FirstOrDefault(
                            d => string.Equals(d.Name, rootName, StringComparison.OrdinalIgnoreCase));
                    if (directory == null)
                    {
                        directory = new Directory(rootName, null);
                        _roots.Add(directory);
                    }
                }

                for (int i = 1; i < filePathParts.Length - 1; i++)
                {
                    var filePathPart = filePathParts[i];

                    var childDirectory = directory.Directories.FirstOrDefault(d => string.Equals(d.Name, filePathPart, StringComparison.OrdinalIgnoreCase));
                    if (childDirectory == null)
                    {
                        childDirectory = new Directory(filePathPart, directory);
                        directory.AddDirectory(childDirectory);
                    }

                    directory = childDirectory;
                }

                var fileName = filePathParts[filePathParts.Length - 1];
                var file = new XapContentFile(xapUri, new Uri(filePath, UriKind.Relative), stream, fileName);
                directory.AddFile(file);
            }

            var contentLoaded = XapContentLoaded;
            if (contentLoaded != null)
            {
                contentLoaded(this, new XapContentLoadedEventArgs(xapUri));
            }

        }

        public bool FileExists(string path)
        {
            var fullPath = GetNormalizedFullPath(path);
            var dirParts = fullPath.Split('\\');

            var rootName = dirParts[0];
            Directory directory = null;

            lock (_roots)
            {
                foreach (var root in _roots)
                {
                    if (string.Equals(root.Name, rootName, StringComparison.OrdinalIgnoreCase))
                    {
                        directory = root;
                        break;
                    }
                }
            }

            if (directory == null)
            {
                return false;
            }

            for (int i = 1; i < dirParts.Length - 1; i++)
            {
                var filePathPart = dirParts[i];

                var childDirectory = directory.Directories.FirstOrDefault(d => string.Equals(d.Name, filePathPart, StringComparison.OrdinalIgnoreCase));
                if (childDirectory == null)
                {
                    return false;
                }

                directory = childDirectory;
            }

            var fileName = dirParts[dirParts.Length - 1];
            var file = directory.Files.FirstOrDefault(f => string.Equals(f.Name, fileName, StringComparison.OrdinalIgnoreCase));

            return file != null;
        }

        public bool DirectoryExists(string path)
        {
            var fullPath = GetNormalizedFullPath(path);
            var dirParts = fullPath.Split('\\');

            var rootName = dirParts[0];
            Directory directory = null;

            lock (_roots)
            {
                foreach (var root in _roots)
                {
                    if (string.Equals(root.Name, rootName, StringComparison.OrdinalIgnoreCase))
                    {
                        directory = root;
                        break;
                    }
                }
            }

            if (directory == null)
            {
                return false;
            }

            for (int i = 1; i < dirParts.Length; i++)
            {
                var filePathPart = dirParts[i];

                var childDirectory = directory.Directories.FirstOrDefault(d => string.Equals(d.Name, filePathPart, StringComparison.OrdinalIgnoreCase));
                if (childDirectory == null)
                {
                    return false;
                }

                directory = childDirectory;
            }

            return true;
        }

        public Stream OpenInputFileStream(string path)
        {
            var fullPath = GetNormalizedFullPath(path);
            var dirParts = fullPath.Split('\\');

            var rootName = dirParts[0];
            Directory directory = null;

            lock (_roots)
            {
                foreach (var root in _roots)
                {
                    if (string.Equals(root.Name, rootName, StringComparison.OrdinalIgnoreCase))
                    {
                        directory = root;
                        break;
                    }
                }
            }

            if (directory == null)
            {
                throw new Exception("Could not find part of the path: " + path);
            }

            for (int i = 1; i < dirParts.Length - 1; i++)
            {
                var filePathPart = dirParts[i];

                var childDirectory = directory.Directories.FirstOrDefault(d => string.Equals(d.Name, filePathPart, StringComparison.OrdinalIgnoreCase));
                if (childDirectory == null)
                {
                    throw new Exception("Could not find part of the path: " + path);
                }

                directory = childDirectory;
            }

            var fileName = dirParts[dirParts.Length - 1];
            var file = directory.Files.FirstOrDefault(f => string.Equals(f.Name, fileName, StringComparison.OrdinalIgnoreCase));
            if (file == null)
            {
                throw new Exception("Could not find part of the path: " + path);
            }

            return file.GetContentStream().Stream;
        }

        public string[] GetFileSystemEntries(string path, string searchPattern, bool includeFiles, bool includeDirectories)
        {
            // TODO consider preventing crazy characters from getting through
            // TODO: How should I handle empty paths? How does unix?
            // Probably should throw exception.
            if (path == string.Empty) path = ".";

            var fullPath = GetNormalizedFullPath(path);
            var dirParts = fullPath.Split('\\');

            var rootName = dirParts[0];
            Directory directory = null;

            lock (_roots)
            {
                foreach (var root in _roots)
                {
                    if (string.Equals(root.Name, rootName, StringComparison.OrdinalIgnoreCase))
                    {
                        directory = root;
                        break;
                    }
                }
            }

            if (directory == null)
            {
                throw new Exception("Could not find part of the path: " + path);
            }

            foreach (var dirPart in dirParts.Skip(1))
            {
                directory = directory.Directories.FirstOrDefault(d => string.Equals(d.Name, dirPart, StringComparison.OrdinalIgnoreCase));
                if (directory == null)
                {
                    throw new Exception("Could not find part of the path: " + path);
                }
            }

            // TODO: test this
            if (string.IsNullOrEmpty(searchPattern)) searchPattern = "*";
            var regexPattern = "^" + searchPattern.Replace(".", "\\.").Replace("*", ".*");
            var regex = new Regex(regexPattern, RegexOptions.IgnoreCase);

            var fileMatches = Enumerable.Empty<string>();
            var directoryMatches = Enumerable.Empty<string>();

            if (includeFiles)
            {
                fileMatches = directory.Files.Where(f => regex.IsMatch(f.Name)).Select(f => f.Path);
            }

            if (includeDirectories)
            {
                directoryMatches = directory.Directories.Where(d => regex.IsMatch(d.Name)).Select(d => d.Path);
            }

            return fileMatches.Concat(directoryMatches).ToArray();
        }

        public string GetFullPath(string path)
        {
            return GetNormalizedFullPath(path).Replace('\\', '/');
        }

        // This is probably overkill
        private string GetNormalizedFullPath(string path)
        {
            string normalizedPath;
            string failure;

            // Should handle unix and windows absolute paths
            if (path[0] == '\\' || path[0] == '/' || (path.Length >= 2 && path[1] == ':'))
            {
                // Absolute
                if (!PathUtil.Normalize(path, out normalizedPath, out failure)) throw new Exception("SHIT");
            }
            else
            {
                // Relative
                if (!PathUtil.Normalize(CurrentDirectory + @"\" + path, out normalizedPath, out failure)) throw new Exception("SHIT");
            }

            return normalizedPath;
        }

        private static bool IsXapServedByWebServer()
        {
            Uri originalUrl = HtmlPage.Document.DocumentUri;
            return !string.Equals(originalUrl.Scheme, "file", StringComparison.OrdinalIgnoreCase);
        }

        public static Uri TryGetMainXapUri()
        {
            if (!IsXapServedByWebServer())
            {
                return null;
            }

            Uri originalUrl = HtmlPage.Document.DocumentUri;
            string xapFile = (string)HtmlPage.Plugin.GetProperty("source");
            if (xapFile == null)
            {
                return null;
            }

            return new Uri(originalUrl, xapFile);
        }

        [DebuggerDisplay("XapContentFile: {Path}")]
        private class XapContentFile
        {
            public Uri XapUri { get; private set; }
            public Uri ContentUri { get; private set; }
            public string Name { get; private set; }
            public Directory Directory { get; set; }

            public string Path
            {
                get
                {
                    if (Directory != null)
                    {
                        return Directory.Path + "/" + Name;
                    }

                    return Name;
                }
            }

            private readonly Stream _xapStream;

            public XapContentFile(Uri xapUri, Uri contentUri, Stream xapStream, string name)
            {
                _xapStream = xapStream;
                XapUri = xapUri;
                ContentUri = contentUri;
                Name = name;
            }

            public StreamResourceInfo GetContentStream()
            {
                if (_xapStream == null)
                {
                    return Application.GetResourceStream(ContentUri);
                }

                if (_xapStream.Position > 0) _xapStream.Seek(0, SeekOrigin.Begin);
                return Application.GetResourceStream(new StreamResourceInfo(_xapStream, null), ContentUri);
            }
        }

        [DebuggerDisplay("Directory: {Path}")]
        private class Directory
        {
            public IList<Directory> Directories { get; private set; }
            public IList<XapContentFile> Files { get; private set; }
            public string Name { get; private set; }
            public Directory Parent { get; private set; }

            public string Path
            {
                get
                {
                    if (Parent != null)
                    {
                        return Parent.Path + "/" + Name;
                    }

                    return Name;
                }
            }

            public Directory(string name, Directory parent)
            {
                Name = name;
                Parent = parent;
                Directories = new List<Directory>();
                Files = new List<XapContentFile>();
            }

            public void AddDirectory(Directory directory)
            {
                if (!Directories.Contains(directory))
                {
                    Directories.Add(directory);
                }

                directory.Parent = this;
            }

            public void AddFile(XapContentFile file)
            {
                if (!Files.Contains(file))
                {
                    Files.Add(file);
                }

                file.Directory = this;
            }
        }

        public class XapContentLoadedEventArgs : EventArgs
        {
            public Uri XapUri { get; private set; }

            public XapContentLoadedEventArgs(Uri xapUri)
            {
                XapUri = xapUri;
            }
        }
    }
}