
#include <stddef.h>
#incldue "stm32f10x.h"
#include "stm32f10x_conf.h"
void delay(unsigned int cat)
{
	while(cat>0)
	{cat--;}
}
int main(void)
{
	RCC_DeInit();
	int cat = 0;
	RCC_APB2PeriphClockCmd(Rcc_APB2Periph_AFIO, ENABLE);
	RCC_APB2PeriphClockCmd(Rcc_APB2Periph_GPIOB, ENABLE);
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);
	
	GPIO_IniTypeDef GPIO_InitStruct;
	PIO_InitStruct.PGIO_Pin= GPIO_PIN_0|GPIO_PIN_1|GPIO_PIN_3|GPIO_PIN_4|GPIO_PIN_8|GPIO_PIN_9|GPIO_PIN_10|GPIO_PIN_11|GPIO_PIN_12|GPIO_PIN_13|GPIO_PIN_14|GPIO_PIN_15;
	GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStruct.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStruct);
	GPIO_Write(GPIOB,0x0700);
	delay(1200000);
	
	while(1){
	cat = 120000;
	while(cat>0){
		GPIO_Write(GPIOB,0x66FD);
		GPIO_Write(GPIOB,0x07FE);
		GPIO_Write(GPIOB,0x3FF7);
		GPIO_Write(GPIOB,0x6FEF);
		cat--;
		}
	cat = 120000;
	while(cat>0){
		GPIO_Write(GPIOB,0x7DFD);
		GPIO_Write(GPIOB,0x5BFE);
		GPIO_Write(GPIOB,0x06F7);
		GPIO_Write(GPIOB,0x3FEF);
		cat--;
		}
	cat = 120000;
	while(cat>0){
		GPIO_Write(GPIOB,0x66FD);
		GPIO_Write(GPIOB,0x06FE);
		GPIO_Write(GPIOB,0x6DF7);
		GPIO_Write(GPIOB,0x06EF);
		cat--;
		}
	GPIO_Write(GPIOB,0x4000);
		delay(1200000);
	}
}
