/*
 * Copyright (c) 1991 Stanford University
 *
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name of Stanford not be used in advertising or
 * publicity pertaining to distribution of the software without specific,
 * written prior permission.  Stanford makes no representations about
 * the suitability of this software for any purpose.  It is provided "as is"
 * without express or implied warranty.
 *
 * STANFORD DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
 * INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.
 * IN NO EVENT SHALL STANFORD BE LIABLE FOR ANY SPECIAL, INDIRECT OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE,
 * DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
 * OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
 * WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

/*
 * ImportCmd - a command for importing graphical objects
 */

#ifndef unidraw_commands_import_h
#define unidraw_commands_import_h

#include <Unidraw/Commands/command.h>

#undef FileChooser
#define FileChooser _lib_iv(FileChooser)

class FileChooser;

class ImportCmd : public Command {
public:
    ImportCmd(ControlInfo*, FileChooser* = nil);
    ImportCmd(Editor* = nil, FileChooser* = nil);
    virtual ~ImportCmd();

    virtual void Execute();
    virtual boolean Reversible();
    virtual GraphicComp* PostDialog();

    virtual Command* Copy();
    virtual ClassId GetClassId();
    virtual boolean IsA(ClassId);

    static GraphicComp* Import(const char*);
    static GraphicComp* TIFF_Image(const char*);
    static GraphicComp* PGM_Image(const char*);
    static GraphicComp* PPM_Image(const char*);
    static GraphicComp* XBitmap_Image(const char*);
private:
    FileChooser* chooser_;

    void Init(FileChooser*);
};

#endif
