/* ****************************************************************************
 *
 * Copyright (c) Microsoft Corporation. 
 *
 * This source code is subject to terms and conditions of the Apache License, Version 2.0. A 
 * copy of the license can be found in the License.html file at the root of this distribution. If 
 * you cannot locate the  Apache License, Version 2.0, please send an email to 
 * ironruby@microsoft.com. By using this source code in any fashion, you are agreeing to be bound 
 * by the terms of the Apache License, Version 2.0.
 *
 * You must not remove this notice, or any other, from this software.
 *
 *
 * ***************************************************************************/

#pragma warning disable 169 // mcs: unused private method
[assembly: IronRuby.Runtime.RubyLibraryAttribute(typeof(RMXPx.RMXPxLibraryInitializer))]

namespace RMXPx {
    using System;
    using Microsoft.Scripting.Utils;
    
    public sealed class RMXPxLibraryInitializer : IronRuby.Builtins.LibraryInitializer {
        protected override void LoadModules() {
            IronRuby.Builtins.RubyClass classRef0 = GetClass(typeof(System.Object));
            IronRuby.Builtins.RubyClass classRef1 = GetClass(typeof(System.Exception));
            
            
            DefineGlobalClass("Bitmap", typeof(RMXPx.Bitmap), 0x00000000, classRef0, LoadBitmap_Instance, null, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, System.String, RMXPx.Bitmap>(RMXPx.BitmapOps.Create), 
                new Func<IronRuby.Builtins.RubyClass, System.Int32, System.Int32, RMXPx.Bitmap>(RMXPx.BitmapOps.Create)
            );
            DefineGlobalClass("Color", typeof(RMXPx.Color), 0x00000008, classRef0, LoadColor_Instance, LoadColor_Class, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32, System.Int32, System.Int32, System.Nullable<System.Int32>, RMXPx.Color>(RMXPx.Color.Create)
            );
            DefineGlobalClass("Graphics", typeof(RMXPx.Graphics), 0x00000008, classRef0, null, LoadGraphics_Class, null, IronRuby.Builtins.RubyModule.EmptyArray);
            DefineGlobalClass("Rect", typeof(RMXPx.Rect), 0x00000008, classRef0, LoadRect_Instance, LoadRect_Class, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32, System.Int32, System.Int32, System.Int32, RMXPx.Rect>(RMXPx.Rect.Create)
            );
            DefineGlobalClass("RGSSError", typeof(RMXPx.RGSSError), 0x00000008, classRef1, null, null, null, IronRuby.Builtins.RubyModule.EmptyArray, 
            new Func<IronRuby.Builtins.RubyClass, System.Object, System.Exception>(RMXPxLibraryInitializer.ExceptionFactory__RGSSError));
            DefineGlobalClass("Sprite", typeof(RMXPx.Sprite), 0x00000000, classRef0, LoadSprite_Instance, null, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, RMXPx.Sprite>(RMXPx.SpriteOps.Create), 
                new Func<IronRuby.Builtins.RubyClass, RMXPx.Viewport, RMXPx.Sprite>(RMXPx.SpriteOps.Create)
            );
            DefineGlobalClass("Tone", typeof(RMXPx.Tone), 0x00000008, classRef0, LoadTone_Instance, LoadTone_Class, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32, System.Int32, System.Int32, System.Nullable<System.Int32>, RMXPx.Tone>(RMXPx.Tone.Create)
            );
            DefineGlobalClass("Viewport", typeof(RMXPx.Viewport), 0x00000008, classRef0, LoadViewport_Instance, null, null, IronRuby.Builtins.RubyModule.EmptyArray, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32, System.Int32, System.Int32, System.Int32, RMXPx.Viewport>(RMXPx.Viewport.Create), 
                new Func<IronRuby.Builtins.RubyClass, RMXPx.Rect, RMXPx.Viewport>(RMXPx.Viewport.Create)
            );
        }
        
        private static void LoadBitmap_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "blt", 0x11, 
                0x0000001eU, 
                new Action<RMXPx.Bitmap, System.Int32, System.Int32, RMXPx.Bitmap, RMXPx.Rect, System.Nullable<System.Int32>>(RMXPx.BitmapOps.Blt)
            );
            
            DefineLibraryMethod(module, "clear", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Bitmap>(RMXPx.BitmapOps.Clear)
            );
            
            DefineLibraryMethod(module, "dispose", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Bitmap>(RMXPx.BitmapOps.Dispose)
            );
            
            DefineLibraryMethod(module, "disposed?", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, System.Boolean>(RMXPx.BitmapOps.GetDisposed)
            );
            
            DefineLibraryMethod(module, "draw_text", 0x11, 
                0x00000000U, 0x00000000U, 
                new Action<RMXPx.Bitmap, System.Int32, System.Int32, System.Int32, System.Int32, System.String, System.Nullable<System.Int32>>(RMXPx.BitmapOps.DrawText), 
                new Action<RMXPx.Bitmap, RMXPx.Rect, System.String, System.Nullable<System.Int32>>(RMXPx.BitmapOps.DrawText)
            );
            
            DefineLibraryMethod(module, "fill_rect", 0x11, 
                0x00000000U, 0x00000000U, 
                new Action<RMXPx.Bitmap, System.Int32, System.Int32, System.Int32, System.Int32, RMXPx.Color>(RMXPx.BitmapOps.FillRect), 
                new Action<RMXPx.Bitmap, RMXPx.Rect, RMXPx.Color>(RMXPx.BitmapOps.FillRect)
            );
            
            DefineLibraryMethod(module, "get_pixel", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, System.Int32, System.Int32, RMXPx.Color>(RMXPx.BitmapOps.GetPixel)
            );
            
            DefineLibraryMethod(module, "height", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, System.Int32>(RMXPx.BitmapOps.GetHeight)
            );
            
            DefineLibraryMethod(module, "hue_change", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Bitmap, System.Int32>(RMXPx.BitmapOps.HueChange)
            );
            
            DefineLibraryMethod(module, "invalidate", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Bitmap>(RMXPx.BitmapOps.Invalidate)
            );
            
            DefineLibraryMethod(module, "rect", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, RMXPx.Rect>(RMXPx.BitmapOps.GetRect)
            );
            
            DefineLibraryMethod(module, "set_pixel", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Bitmap, System.Int32, System.Int32, RMXPx.Color>(RMXPx.BitmapOps.SetPixel)
            );
            
            DefineLibraryMethod(module, "stretch_blt", 0x11, 
                0x0000000eU, 
                new Action<RMXPx.Bitmap, RMXPx.Rect, RMXPx.Bitmap, RMXPx.Rect, System.Nullable<System.Int32>>(RMXPx.BitmapOps.StretchBlt)
            );
            
            DefineLibraryMethod(module, "text_size", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, System.String, RMXPx.Rect>(RMXPx.BitmapOps.GetTextSize)
            );
            
            DefineLibraryMethod(module, "width", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Bitmap, System.Int32>(RMXPx.BitmapOps.GetWidth)
            );
            
        }
        
        private static void LoadColor_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_dump", 0x11, 
                0x00000000U, 
                new Func<IronRuby.Runtime.ConversionStorage<IronRuby.Runtime.IntegerValue>, IronRuby.Runtime.ConversionStorage<System.Double>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, RMXPx.Color, System.Nullable<System.Int32>, IronRuby.Builtins.MutableString>(RMXPx.Color.Dump)
            );
            
            DefineLibraryMethod(module, "alpha", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Color, System.Int32>(RMXPx.Color.GetAlpha)
            );
            
            DefineLibraryMethod(module, "alpha=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Color, System.Int32>(RMXPx.Color.SetAlpha)
            );
            
            DefineLibraryMethod(module, "blue", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Color, System.Int32>(RMXPx.Color.GetBlue)
            );
            
            DefineLibraryMethod(module, "blue=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Color, System.Int32>(RMXPx.Color.SetBlue)
            );
            
            DefineLibraryMethod(module, "green", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Color, System.Int32>(RMXPx.Color.GetGreen)
            );
            
            DefineLibraryMethod(module, "green=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Color, System.Int32>(RMXPx.Color.SetGreen)
            );
            
            DefineLibraryMethod(module, "red", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Color, System.Int32>(RMXPx.Color.GetRed)
            );
            
            DefineLibraryMethod(module, "red=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Color, System.Int32>(RMXPx.Color.SetRed)
            );
            
        }
        
        private static void LoadColor_Class(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_load", 0x21, 
                0x00000000U, 
                new Func<IronRuby.Builtins.RubyClass, IronRuby.Builtins.MutableString, RMXPx.Color>(RMXPx.Color.Load)
            );
            
        }
        
        private static void LoadGraphics_Class(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "frame_count", 0x21, 
                0x00000000U, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32>(RMXPx.Graphics.GetFrameCount)
            );
            
            DefineLibraryMethod(module, "frame_count=", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass, System.Int32>(RMXPx.Graphics.SetFrameCount)
            );
            
            DefineLibraryMethod(module, "frame_rate", 0x21, 
                0x00000000U, 
                new Func<IronRuby.Builtins.RubyClass, System.Int32>(RMXPx.Graphics.GetFrameRate)
            );
            
            DefineLibraryMethod(module, "frame_rate=", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass, System.Int32>(RMXPx.Graphics.SetFrameRate)
            );
            
            DefineLibraryMethod(module, "frame_reset", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass>(RMXPx.Graphics.FrameReset)
            );
            
            DefineLibraryMethod(module, "freeze", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass>(RMXPx.Graphics.Freeze)
            );
            
            DefineLibraryMethod(module, "surface_bmp", 0x21, 
                0x00000000U, 0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass, RMXPx.Bitmap>(RMXPx.Graphics.SetSurfaceBmp), 
                new Func<IronRuby.Builtins.RubyClass, RMXPx.Bitmap>(RMXPx.Graphics.GetSurfaceBmp)
            );
            
            DefineLibraryMethod(module, "transition", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass>(RMXPx.Graphics.Transition)
            );
            
            DefineLibraryMethod(module, "update", 0x21, 
                0x00000000U, 
                new Action<IronRuby.Builtins.RubyClass>(RMXPx.Graphics.Update)
            );
            
        }
        
        private static void LoadRect_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_dump", 0x11, 
                0x00000000U, 
                new Func<IronRuby.Runtime.ConversionStorage<IronRuby.Runtime.IntegerValue>, IronRuby.Runtime.ConversionStorage<System.Double>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, RMXPx.Rect, System.Nullable<System.Int32>, IronRuby.Builtins.MutableString>(RMXPx.Rect.Dump)
            );
            
            DefineLibraryMethod(module, "height", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Rect, System.Int32>(RMXPx.Rect.GetHeight)
            );
            
            DefineLibraryMethod(module, "height=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Rect, System.Int32>(RMXPx.Rect.SetHeight)
            );
            
            DefineLibraryMethod(module, "width", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Rect, System.Int32>(RMXPx.Rect.GetWidth)
            );
            
            DefineLibraryMethod(module, "width=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Rect, System.Int32>(RMXPx.Rect.SetWidth)
            );
            
            DefineLibraryMethod(module, "x", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Rect, System.Int32>(RMXPx.Rect.GetX)
            );
            
            DefineLibraryMethod(module, "x=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Rect, System.Int32>(RMXPx.Rect.SetX)
            );
            
            DefineLibraryMethod(module, "y", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Rect, System.Int32>(RMXPx.Rect.GetY)
            );
            
            DefineLibraryMethod(module, "y=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Rect, System.Int32>(RMXPx.Rect.SetY)
            );
            
        }
        
        private static void LoadRect_Class(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_load", 0x21, 
                0x00000000U, 
                new Func<IronRuby.Builtins.RubyClass, IronRuby.Builtins.MutableString, RMXPx.Rect>(RMXPx.Rect.Load)
            );
            
        }
        
        private static void LoadSprite_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "angle", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetAngle)
            );
            
            DefineLibraryMethod(module, "angle=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetAngle)
            );
            
            DefineLibraryMethod(module, "bitmap", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, RMXPx.Bitmap>(RMXPx.SpriteOps.GetBitmap)
            );
            
            DefineLibraryMethod(module, "bitmap=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, RMXPx.Bitmap>(RMXPx.SpriteOps.SetBitmap)
            );
            
            DefineLibraryMethod(module, "blend_type", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetBlendType)
            );
            
            DefineLibraryMethod(module, "blend_type=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetBlendType)
            );
            
            DefineLibraryMethod(module, "bush_depth", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetBushDepth)
            );
            
            DefineLibraryMethod(module, "bush_depth=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetBushDepth)
            );
            
            DefineLibraryMethod(module, "color", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, RMXPx.Color>(RMXPx.SpriteOps.GetColor)
            );
            
            DefineLibraryMethod(module, "color=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, RMXPx.Color>(RMXPx.SpriteOps.SetColor)
            );
            
            DefineLibraryMethod(module, "dispose", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite>(RMXPx.SpriteOps.Dispose)
            );
            
            DefineLibraryMethod(module, "disposed?", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Boolean>(RMXPx.SpriteOps.GetDisposed)
            );
            
            DefineLibraryMethod(module, "flash", 0x11, 
                0x00020000U, 
                new Action<RMXPx.Sprite, RMXPx.Color, System.Int32>(RMXPx.SpriteOps.Flash)
            );
            
            DefineLibraryMethod(module, "mirror", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Boolean>(RMXPx.SpriteOps.GetMirror)
            );
            
            DefineLibraryMethod(module, "mirror=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Boolean>(RMXPx.SpriteOps.SetMirror)
            );
            
            DefineLibraryMethod(module, "opacity", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetOpacity)
            );
            
            DefineLibraryMethod(module, "opacity=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetOpacity)
            );
            
            DefineLibraryMethod(module, "ox", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetOX)
            );
            
            DefineLibraryMethod(module, "ox=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetOX)
            );
            
            DefineLibraryMethod(module, "oy", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetOY)
            );
            
            DefineLibraryMethod(module, "oy=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetOY)
            );
            
            DefineLibraryMethod(module, "src_rect", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, RMXPx.Rect>(RMXPx.SpriteOps.GetSrcRect)
            );
            
            DefineLibraryMethod(module, "src_rect=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, RMXPx.Rect>(RMXPx.SpriteOps.SetSrcRect)
            );
            
            DefineLibraryMethod(module, "tone", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, RMXPx.Tone>(RMXPx.SpriteOps.GetTone)
            );
            
            DefineLibraryMethod(module, "tone=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, RMXPx.Tone>(RMXPx.SpriteOps.SetTone)
            );
            
            DefineLibraryMethod(module, "update", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite>(RMXPx.SpriteOps.Update)
            );
            
            DefineLibraryMethod(module, "viewport", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, RMXPx.Viewport>(RMXPx.SpriteOps.GetViewport)
            );
            
            DefineLibraryMethod(module, "visible", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Boolean>(RMXPx.SpriteOps.GetVisible)
            );
            
            DefineLibraryMethod(module, "visible=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Boolean>(RMXPx.SpriteOps.SetVisible)
            );
            
            DefineLibraryMethod(module, "x", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetX)
            );
            
            DefineLibraryMethod(module, "x=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetX)
            );
            
            DefineLibraryMethod(module, "y", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetY)
            );
            
            DefineLibraryMethod(module, "y=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetY)
            );
            
            DefineLibraryMethod(module, "z", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetZ)
            );
            
            DefineLibraryMethod(module, "z=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetZ)
            );
            
            DefineLibraryMethod(module, "zoom_x", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetZoomX)
            );
            
            DefineLibraryMethod(module, "zoom_x=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetZoomX)
            );
            
            DefineLibraryMethod(module, "zoom_y", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.GetZoomY)
            );
            
            DefineLibraryMethod(module, "zoom_y=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Sprite, System.Int32>(RMXPx.SpriteOps.SetZoomY)
            );
            
        }
        
        private static void LoadTone_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_dump", 0x11, 
                0x00000000U, 
                new Func<IronRuby.Runtime.ConversionStorage<IronRuby.Runtime.IntegerValue>, IronRuby.Runtime.ConversionStorage<System.Double>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, IronRuby.Runtime.ConversionStorage<IronRuby.Builtins.MutableString>, RMXPx.Tone, System.Nullable<System.Int32>, IronRuby.Builtins.MutableString>(RMXPx.Tone.Dump)
            );
            
            DefineLibraryMethod(module, "blue", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Tone, System.Int32>(RMXPx.Tone.GetBlue)
            );
            
            DefineLibraryMethod(module, "blue=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Tone, System.Int32>(RMXPx.Tone.SetBlue)
            );
            
            DefineLibraryMethod(module, "green", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Tone, System.Int32>(RMXPx.Tone.GetGreen)
            );
            
            DefineLibraryMethod(module, "green=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Tone, System.Int32>(RMXPx.Tone.SetGreen)
            );
            
            DefineLibraryMethod(module, "red", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Tone, System.Int32>(RMXPx.Tone.GetRed)
            );
            
            DefineLibraryMethod(module, "red=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Tone, System.Int32>(RMXPx.Tone.SetRed)
            );
            
            DefineLibraryMethod(module, "set", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Tone, System.Int32, System.Int32, System.Int32, System.Nullable<System.Int32>>(RMXPx.Tone.Set)
            );
            
        }
        
        private static void LoadTone_Class(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "_load", 0x21, 
                0x00000000U, 
                new Func<IronRuby.Builtins.RubyClass, IronRuby.Builtins.MutableString, RMXPx.Tone>(RMXPx.Tone.Load)
            );
            
        }
        
        private static void LoadViewport_Instance(IronRuby.Builtins.RubyModule/*!*/ module) {
            DefineLibraryMethod(module, "color", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, RMXPx.Color>(RMXPx.Viewport.GetColor)
            );
            
            DefineLibraryMethod(module, "color=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, RMXPx.Color>(RMXPx.Viewport.SetColor)
            );
            
            DefineLibraryMethod(module, "dispose", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport>(RMXPx.Viewport.Dispose)
            );
            
            DefineLibraryMethod(module, "disposed?", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, System.Boolean>(RMXPx.Viewport.GetDisposed)
            );
            
            DefineLibraryMethod(module, "flash", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, RMXPx.Color, System.Int32>(RMXPx.Viewport.Flash)
            );
            
            DefineLibraryMethod(module, "ox", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.GetOX)
            );
            
            DefineLibraryMethod(module, "ox=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.SetOX)
            );
            
            DefineLibraryMethod(module, "oy", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.GetOY)
            );
            
            DefineLibraryMethod(module, "oy=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.SetOY)
            );
            
            DefineLibraryMethod(module, "rect", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, RMXPx.Rect>(RMXPx.Viewport.GetRect)
            );
            
            DefineLibraryMethod(module, "rect=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, RMXPx.Rect>(RMXPx.Viewport.SetRect)
            );
            
            DefineLibraryMethod(module, "tone", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, RMXPx.Tone>(RMXPx.Viewport.GetTone)
            );
            
            DefineLibraryMethod(module, "tone=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, RMXPx.Tone>(RMXPx.Viewport.SetTone)
            );
            
            DefineLibraryMethod(module, "update", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport>(RMXPx.Viewport.Update)
            );
            
            DefineLibraryMethod(module, "visible", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, System.Boolean>(RMXPx.Viewport.GetVisible)
            );
            
            DefineLibraryMethod(module, "visible=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, System.Boolean>(RMXPx.Viewport.SetVisible)
            );
            
            DefineLibraryMethod(module, "z", 0x11, 
                0x00000000U, 
                new Func<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.GetZ)
            );
            
            DefineLibraryMethod(module, "z=", 0x11, 
                0x00000000U, 
                new Action<RMXPx.Viewport, System.Int32>(RMXPx.Viewport.SetZ)
            );
            
        }
        
        public static System.Exception/*!*/ ExceptionFactory__RGSSError(IronRuby.Builtins.RubyClass/*!*/ self, [System.Runtime.InteropServices.DefaultParameterValueAttribute(null)]object message) {
            return IronRuby.Runtime.RubyExceptionData.InitializeException(new RMXPx.RGSSError(IronRuby.Runtime.RubyExceptionData.GetClrMessage(self, message), (System.Exception)null), message);
        }
        
    }
}

