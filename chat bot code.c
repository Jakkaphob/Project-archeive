#include <stddef.h>
#include "stm32f10x.h"
#include "stm32f10x_conf.h"

void USART1_sendC(unsigned char c){
	while(USART_GetFlagStatus(USART1,USART_FLAG_TXE)==RESET);
	USART_SendData(USART1,(unsigned char) c);
}

char USART1_getC(){
	while(USART_GetFlagStatus(USART1,USART_FLAG_RXNE)==RESET);
	return(USART_ReceiveData(USART1));
}

int main(void){
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA|RCC_APB2Periph_AFIO|RCC_APB2Periph_USART1,ENABLE);
//Tx
	GPIO_InitTypeDef GPIO_InitStruct;
	GPIO_InitStruct.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStruct.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOA, &GPIO_InitStruct);
//Rx
	GPIO_InitStruct.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStruct.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStruct);
//usart
	USART_InitTypeDef usart1_init_struct;
	usart1_init_struct.USART_BaudRate = 19200;
	usart1_init_struct.USART_WordLength = USART_WordLength_8b;
	usart1_init_struct.USART_StopBits = USART_StopBits_1;
	usart1_init_struct.USART_Parity = USART_Parity_No;
	usart1_init_struct.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	usart1_init_struct.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USART_Init(USART1, &usart1_init_struct);
	USART_Cmd(USART1, ENABLE);

	char sData;
	char input[50];
	int i = 0,j;
	unsigned char *msg,*ans;

	char question_1[50] =  "Hello\n";
	char question_2[50] =  "Nice to meet you\n";
	char question_3[50] =  "What is your hobby\n";
	char question_4[50] =  "Tell me something\n";
	char question_5[50] =  "Bye\n";

	while(1){
		msg = (unsigned char *) "\n\rHello World\n\rNice to meet you\n\rI can chat with you\n\r\0";
		i = 0;
		while(msg[i] != '\0'){
			USART1_sendC(msg[i]);
			i++;
		}
		i = 0;
//--------------------------------------------------------------------------------------------
		while(1){;
			sData = USART1_getC();
			input[i] = sData;
			USART1_sendC(input[i]); //echo
			i++;

			if(sData == '\n' || sData == '\r'){
				USART1_sendC('\n');
				USART1_sendC('\r');
				USART1_sendC(':');

				if(input[0] == question_1[0] && input[1] == question_1[1] && input[2] == question_1[2]){
					ans = (unsigned char *) " Hello, Good to see you.\n\r\0";
				}
				else if(input[0] == question_2[0] && input[1] == question_2[1] && input[2] == question_2[2]){
					ans = (unsigned char *) " Nice to meet you too.\n\r\0";
				}
				else if(input[0] == question_3[0] && input[1] == question_3[1] && input[2] == question_3[2]){
					ans = (unsigned char *) " My hobby is chatting online.\n\r\0";
				}
				else if(input[0] == question_4[0] && input[1] == question_4[1] && input[2] == question_4[2]){
					ans = (unsigned char *) " Terminator is a bad robot.\n\r\0";
				}
				else if(input[0] == question_5[0] && input[1] == question_5[1] && input[2] == question_5[2]){
					ans = (unsigned char *) " Ok, see you later.\n\r\0";
				}
				else{
					ans = (unsigned char *) " I do not understand the question.\n\r\0";
				}
				j =0;
				while(ans[j] != '\0'){
					USART1_sendC(ans[j]);
					j++;
				}
				i =0;
			}
		}
	}
}
