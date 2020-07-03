#ifndef LANGUAGE_H
#define LANGUAGE_H

typedef enum
{ 
    ENGLISH,
    FRENCH,
    GERMAN,
    SPANISH,
    LAST_LANGUAGE 
} LANGUAGE;

typedef struct
{
    /*
     * Maximum Length
     */ 
    unsigned int const len;

    /*
     * Array of pointers to language specific string
     */ 
    char const * const text[LAST_LANGUAGE];

} STRING;


typedef enum
{
    TEST_PATTERNS,
    DROP_SHADOW_TEST,
    STRIPED_SPRITE_TEST,
    LAG_TEST,
    MANUAL_LAG_TEST,
    SCROLL_TEST,
    GRID_SCROLL_TEST,
    HORIZONTAL_STRIPES,
    CHECKERBOARD,
    BACKLIT_ZONE_TEST,
    DIAGONAL_TEST,
    ALTERNATING_RESOLUTION_TEST,
    SOUND_TEST,
    VIDEO_MODE,
    OPTIONS,
    HELP,
    LAST_STR
} STR;

static const STRING strings[LAST_STR] =
{
    { /* TEST_PATTERNS */
        15,
        {
            "Test Patterns >", /* English */
            "Test Patterns >", /* French */
            "Test Patterns >"  /* German */
        }
    },
    { /* DROP_SHADOW_TEST */
        16,
        {
            "Drop Shadow Test", /* English */
            "Drop Shadow Test", /* French */
            "Drop Shadow Test"  /* German */
        }
    },
    { /* STRIPED_SPRITE_TEST */
        19,
        {
            "Striped Sprite Test", /* English */
            "Striped Sprite Test", /* French */
            "Striped Sprite Test"  /* German */
        }
    },
    { /* LAG_TEST */
        8,
        {
            "Lag Test", /* English */
            "Lag Test", /* French */
            "Lag Test"  /* German */
        }
    },
    { /* MANUAL_LAG_TEST */
        15,
        {
            "Manual Lag Test", /* English */
            "Manual Lag Test", /* French */
            "Manual Lag Test"  /* German */
        }
    },
    { /* SCROLL_TEST */
        11,
        {
            "Scroll Test", /* English */
            "Scroll Test", /* French */
            "Scroll Test"  /* German */
        }
    },
    { /* GRID_SCROLL_TEST */
        16,
        {
            "Grid Scroll Test", /* English */
            "Grid Scroll Test", /* French */
            "Grid Scroll Test"  /* German */
        }
    },
    { /* HORIZONTAL_STRIPES */
        18,
        {
            "Horizontal Stripes", /* English */
            "Horizontal Stripes", /* French */
            "Horizontal Stripes"  /* German */
        }
    },
    { /* CHECKERBOARD */
        12,
        {
            "Checkerboard", /* English */
            "Checkerboard", /* French */
            "Checkerboard"  /* German */
        }
    },
    { /* BACKLIT_ZONE_TEST */
        26,
        {
            "Backlit Zone Test", /* English */
            "Backlit Zone Test", /* French */
            "Test der beleuchteten Zone"  /* German */
        }
    },
    { /* DIAGONAL_TEST */
        13,
        {
            "Diagonal Test", /* English */
            "Diagonal Test", /* French */
            "Diagonaltest"  /* German */
        }
    },
    { /* ALTERNATING_RESOLUTION_TEST */
        29,
        {
            "Alternating Resolution Test", /* English */
            "Alternating Resolution Test", /* French */
            "Alternierender Auflosungstest"  /* German */
        }
    },
    { /* SOUND_TEST */
        10,
        {
            "Sound Test", /* English */
            "Sound Test", /* French */
            "Soundtest"  /* German */
        }
    },
    { /* VIDEO_MODE */
        11,
        {
            "Video Mode", /* English */
            "Video Mode", /* French */
            "Video Modus"  /* German */
        }
    },
    { /* OPTIONS */
        11,
        {
            "Options", /* English */
            "Les Options", /* French */
            "Optionen"  /* German */
        }
    },
    { /* HELP */
        9,
        {
            "Help", /* English */
            "Aidez-moi", /* French */
            "Hilfe"  /* German */
        }
    }
};

void SetLanguage(unsigned int language);

unsigned int GetLanguage();

unsigned char * GetStr(unsigned int str_no);

#endif
