
/* This work is copyrighted. See COPYRIGHT.OLD & COPYRIGHT.NEW for   *
*  details. If they are missing then this copy is in violation of    *
*  the copyright conditions.                                        */

/*
**	lib_addch.c
**
**	The routine waddch().
**
*/

#include "curses.h"
#include "curses.priv.h"
#include "unctrl.h"

int
waddch( WINDOW	*win, chtype c)
{
int	x, y;
int	newx;
chtype	ch = c;

#ifdef UNTRACE  
	if (_tracing)
	    _tracef("waddch(%x,%c (%x)) called", win, ch, ch);
#endif

	x = win->_curx;
	y = win->_cury;

	if (y > win->_maxy  ||  x > win->_maxx  ||  y < 0  ||  x < 0)
	    return(ERR);

	switch (ch)
	{
	    case '\t':
			for (newx = x + (8 - (x & 07)); x < newx; x++)
		    	if (waddch(win, ' ') == ERR)
				return(ERR);
			return(OK);
	    case '\n':
			wclrtoeol(win);
	    	x = 0;
			goto newline;
	    case '\r':
			x = 0;
			break;
	    case '\b':
			if (--x < 0)
			    x = 0;
			break;
	    default:
		if (ch < ' ')
		    return(waddstr(win, unctrl(ch)));

		ch |= win->_attrs;

		if (win->_line[y][x] != ch)
		{
		    if (win->_firstchar[y] == _NOCHANGE)
				win->_firstchar[y] = win->_lastchar[y] = x;
		    else if (x < win->_firstchar[y])
				win->_firstchar[y] = x;
		    else if (x > win->_lastchar[y])
				win->_lastchar[y] = x;

		}

		win->_line[y][x++] = ch;
		if (x > win->_maxx)
		{
		    x = 0;
newline:
		    y++;
		    if (y > win->_regbottom) {
				y--;
				if (win->_scroll)
				    scroll(win);
				else
				    return ERR;
		    }
		}
		break;
	}

	win->_curx = x;
	win->_cury = y;

	return(OK);
}
