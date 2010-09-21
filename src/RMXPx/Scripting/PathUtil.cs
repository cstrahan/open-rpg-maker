using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace RMXPx.Scripting
{
    public class PathUtil
    {
        private static char DIR_SEPARATOR_CHAR = Path.DirectorySeparatorChar;
        private static string DIR_SEPARATOR_STRING = Path.DirectorySeparatorChar.ToString();
        private const string CURRENT_DIR_SINGLEDOT = ".";
        private const string PARENT_DIR_DOUBLEDOT = "..";

        // private static readonly Regex MULTIPLE_SLASH_PATTERN = new Regex(@"[\\/]");

        ///// <summary>
        ///// Expands and normalizes paths that may contain ".." or "." patterns.
        ///// </summary>
        //public static string GetFullPathUnix(string currentDirectory, string path)
        //{
        //    var exceptionMessage =
        //        string.Format("Could not get full path:\n  currentDirectory: {0}\n  path: {1}",
        //          currentDirectory, path);

        //    string normalizedPath;
        //    string failure;

        //    if (path[0] == '\\' || path[0] == '/')
        //    {
        //        // Absolute
        //        if (!PathUtil.Normalize(path, out normalizedPath, out failure)) throw new Exception(exceptionMessage);
        //    }
        //    else
        //    {
        //        // Relative
        //        if (!PathUtil.Normalize(currentDirectory + @"\" + path, out normalizedPath, out failure)) throw new Exception(exceptionMessage);
        //    }

        //    return normalizedPath.Replace('\\', '/');
        //}

        ///// <summary>
        ///// Expands and normalizes paths that may contain ".." or "." patterns.
        ///// </summary>
        //public static string GetFullPathWindows(string currentDirectory, string path)
        //{
        //    var exceptionMessage =
        //        string.Format("Could not get full path:\n  currentDirectory: {0}\n  path: {1}",
        //          currentDirectory, path);

        //    string normalizedPath;
        //    string failure;

        //    if (path.Length >= 3 && path[1] == ':' && (path[2] == '\\' || path[2] == '/')) // Absolute
        //    {
        //        if (!PathUtil.Normalize(path, out normalizedPath, out failure)) throw new Exception(exceptionMessage);
        //    }
        //    else if (path.Length == 2 && path[1] == ':') // Swap drive letter in path
        //    {
        //        if (string.IsNullOrEmpty(currentDirectory))
        //        {
        //            var message =
        //                string.Format("Could not get drive relative path:\n  currentDirectory: {0}\n  path: {1}",
        //                              currentDirectory, path);
        //            throw new Exception(message);
        //        }

        //        var normalizedCurrentDirectory = MULTIPLE_SLASH_PATTERN.Replace(currentDirectory, @"\");
        //        var indexOfFirstSlash = normalizedCurrentDirectory.IndexOf('\\');
        //        var currentDirectoryWithoutDriveLetter = normalizedCurrentDirectory.Remove(0, indexOfFirstSlash + 1);
        //        var targetDriveLetter = path[0];

        //        if (!PathUtil.Normalize(targetDriveLetter + @"\" + currentDirectoryWithoutDriveLetter,
        //            out normalizedPath, out failure)) throw new Exception("SHIT");
        //    }
        //    else if (path[0] == '\\' || path[0] == '/') // Relative to root of drive letter
        //    {
        //        if (string.IsNullOrEmpty(currentDirectory))
        //        {
        //            throw new Exception(exceptionMessage);
        //        }

        //        if (!PathUtil.Normalize(currentDirectory[0] + path, out normalizedPath, out failure)) throw new Exception(exceptionMessage);
        //    }
        //    else // Relative
        //    {
        //        if (!PathUtil.Normalize(currentDirectory + @"\" + path, out normalizedPath, out failure)) throw new Exception(exceptionMessage);
        //    }

        //    return normalizedPath;
        //}

        // TODO: Need to thoroughly test this
        // Requires absolute path
        internal static bool Normalize(string inPath, out string outPath, out string failure)
        {
            if (inPath.Length == 0)
            {
                outPath = inPath;
                failure = "";
                return true;
            }

            bool success;

            if (inPath[0] == '/' || inPath[0] == '\\')
            {
                success = TryResolveInnerSpecialDir(NormalizePath("." + inPath), out outPath, out failure);
                outPath = outPath.Remove(0, 1);
            }
            else
            {
                success = TryResolveInnerSpecialDir(NormalizePath(inPath), out outPath, out failure);
            }

            return success;
        }

        private static bool ContainsInnerSpecialDir(string path)
        {
            // These cases should have been handled by the calling method and cannot be handled
            // Debug.Assert(path != null);
            // Debug.Assert(path.Length != 0);
            // Debug.Assert(path == NormalizePath(path));

            // Analyze if a /./ or a /../ donc come after a valid DirectoryName
            string[] pathDirs = path.Split(DIR_SEPARATOR_CHAR);
            bool bNextDoubleDotParentDirIsInnerSpecial = false;
            bool bNextSingleDotCurrentDirIsInnerSpecial = false;
            foreach (string pathDir in pathDirs)
            {
                if (pathDir == CURRENT_DIR_SINGLEDOT)
                {
                    if (bNextSingleDotCurrentDirIsInnerSpecial)
                    {
                        return true;
                    }
                }
                else if (pathDir == PARENT_DIR_DOUBLEDOT)
                {
                    if (bNextDoubleDotParentDirIsInnerSpecial)
                    {
                        return true;
                    }
                }
                else
                {
                    bNextDoubleDotParentDirIsInnerSpecial = true;
                }
                bNextSingleDotCurrentDirIsInnerSpecial = true;
            }

            return false;
        }



        private static bool TryResolveInnerSpecialDir(string path, out string pathResolved, out string failureReason)
        {
            // These cases should have been handled by the calling method and cannot be handled
            //// Debug.Assert(path != null);
            //// Debug.Assert(path.Length != 0);
            //// Debug.Assert(path == NormalizePath(path));

            failureReason = string.Empty; // <- failureReason empty by default 
            pathResolved = string.Empty;  // <- pathResolved is empty by default

            // TryResolveInnerSpecialDir() is never called without calling first ContainsInnerSpecialDir()
            //// Debug.Assert(ContainsInnerSpecialDir(path));

            bool bPathIsAbolute = !CanOnlyBeARelativePath(path);


            string[] pathDirs = path.Split(DIR_SEPARATOR_CHAR);
            //// Debug.Assert(pathDirs.Length > 0);
            Stack<string> dirStack = new Stack<string>();
            bool bNextDoubleDotParentDirIsInnerSpecial = false;
            bool bNextSingleDotCurrentDirIsInnerSpecial = false;
            foreach (string dir in pathDirs)
            {
                if (dir == CURRENT_DIR_SINGLEDOT)
                {
                    if (bNextSingleDotCurrentDirIsInnerSpecial)
                    {
                        // Just ignore InnerSpecial SingleDot
                        continue;
                    }
                    else
                    {
                        dirStack.Push(dir);
                    }
                }
                else if (dir == PARENT_DIR_DOUBLEDOT)
                {
                    if (bNextDoubleDotParentDirIsInnerSpecial)
                    {
                        // This condition can't be reached because of next conditions
                        /*if (dirStack.Count == 0) {
                           failureReason = @"The path {" + path + @"} references a non-existing parent dir \..\, it cannot be resolved";
                           return false;
                        }*/
                        if (bPathIsAbolute && dirStack.Count == 1)
                        {
                            failureReason = @"The path {" + path + @"} references the parent dir \..\ of the root dir {" + pathDirs[0] + "}, it cannot be resolved";
                            return false;
                        }
                        string dirToRemove = dirStack.Peek();
                        if (dirToRemove == CURRENT_DIR_SINGLEDOT)
                        {
                            // Debug.Assert(dirStack.Count == 1);
                            failureReason = @"The path {" + path + @"} references the parent dir \..\ of the current root dir .\, it cannot be resolved";
                            return false;
                        }
                        if (dirToRemove == PARENT_DIR_DOUBLEDOT)
                        {
                            failureReason = @"The path {" + path + @"} references the parent dir \..\ of a parent dir \..\, it cannot be resolved";
                            return false;
                        }
                        dirStack.Pop();
                    }
                    else
                    {
                        dirStack.Push(dir);
                    }
                }
                else
                {
                    dirStack.Push(dir);
                    bNextDoubleDotParentDirIsInnerSpecial = true;
                }
                bNextSingleDotCurrentDirIsInnerSpecial = true;
            }

            // Concatenate the dirs
            StringBuilder stringBuilder = new StringBuilder(path.Length);

            // Notice that the dirs are reverse ordered, that's why we use Insert(0,
            foreach (string dir in dirStack)
            {
                stringBuilder.Insert(0, DIR_SEPARATOR_STRING);
                stringBuilder.Insert(0, dir);
            }
            // Remove the last DIR_SEPARATOR
            stringBuilder.Length = stringBuilder.Length - 1;
            pathResolved = stringBuilder.ToString();
            // Debug.Assert(pathResolved == NormalizePath(pathResolved));
            return true;
        }

        private static string NormalizePath(string path)
        {
            // Debug.Assert(path != null && path.Length > 0);
            path = path.Replace('/', DIR_SEPARATOR_CHAR);

            // EventuallyRemoveConsecutiveDirSeparator
            string consecutiveDirSeparator = DIR_SEPARATOR_STRING + DIR_SEPARATOR_STRING;
            while (path.IndexOf(consecutiveDirSeparator) != -1)
            {
                path = path.Replace(consecutiveDirSeparator, DIR_SEPARATOR_STRING);
            }


            // EventuallyRemoveEndingDirSeparator
            while (true)
            {
                // Debug.Assert(path.Length > 0);
                char lastChar = path[path.Length - 1];
                if (lastChar != DIR_SEPARATOR_CHAR)
                {
                    break;
                }
                path = path.Substring(0, path.Length - 1);
            }

            return path;
        }

        private static bool CanOnlyBeARelativePath(string path)
        {
            // Debug.Assert(path != null);
            // Debug.Assert(path.Length >= 1);
            return path[0] == '.';
        }
    }
}