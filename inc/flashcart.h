#ifndef FLASHCART_TARGET_TYPE
#define 	FLASHCART_TARGET_TYPE	ALL
#endif
#ifndef FLASHCART_TARGET_REV
#define 	FLASHCART_TARGET_REV	0
#endif

#if defined(FLASHCART_TARGET_TYPE) && FLASHCART_TARGET_TYPE == ED64
void edUsbListener( void );
void edInitialize( void );
#endif