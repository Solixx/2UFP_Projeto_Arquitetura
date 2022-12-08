#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <ctype.h>
#include <time.h>

void zerarTabuleiro(char tabuleiro[10][10]);
int gerarlinhaAleatorio();
int gerarColunaAleatorio();
int gerarAxisAleatorio();
void displayTabuleiro(char tabuleiro[10][10]);
void gerarCarrier(char tabuleiro[10][10]);
void gerarBattleship(char tabuleiro[10][10]);
void gerarDestroyer(char tabuleiro[10][10]);
void gerarSubmarine(char tabuleiro[10][10]);
void gerarBoat(char tabuleiro[10][10]);

int main() {
    char tabuleiro[10][10];
    zerarTabuleiro(tabuleiro);
    time_t t1;
    srand((unsigned ) time(&t1));
    gerarCarrier(tabuleiro);
    gerarCarrier(tabuleiro);
    //gerarBattleship(tabuleiro);
    //gerarDestroyer(tabuleiro);
    //gerarSubmarine(tabuleiro);
    //gerarBoat(tabuleiro);

    displayTabuleiro(tabuleiro);

    return 0;
}

void zerarTabuleiro(char tabuleiro[10][10]){
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
            tabuleiro[i][j] = '0';
        }
    }
}

int gerarlinhaAleatorio(){
    int r = 0;
    for (int i = 0; i < 1; ++i) {
        r = rand()%10;
    }
    return r;
}

int gerarColunaAleatorio(){
    int r = 0;
    for (int i = 0; i < 1; ++i) {
        r = rand()%10;
    }
    return r;
}

int gerarAxisAleatorio(){
    int r = 0;
    for (int i = 0; i < 1; ++i) {
        r = rand()%2;
    }
    return r;
}

void displayTabuleiro(char tabuleiro[10][10]){
    for (int i = 0; i < 10; ++i) {
        for (int j = 0; j < 10; ++j) {
            printf("%c ", tabuleiro[i][j]);
        }
        printf("\n");
    }
}

void gerarCarrier(char tabuleiro[10][10]){
    char carrier = 'C';
    int linha = 0, coluna = 0;
    int tempLinha = 0, tempColuna = 0, erro = 0, size = 5;
    do{
        erro = 0;
        size = 5;
        do{
            linha = gerarlinhaAleatorio();
            coluna = gerarColunaAleatorio();
            if(linha >= 10 || coluna >= 10) continue;
            if(tabuleiro[linha][coluna] == '0'){
                break;
            }
        } while (tabuleiro[linha][coluna] != 0);
        tempColuna = coluna;
        tempLinha = linha;
        int axis = gerarAxisAleatorio();
        if(axis != 1){  //Horizontal - Tá entre 0-1
            for (int i = 0; i < size; ++i) {
                if(tempColuna < 0) tempColuna = 0;
                if(erro == 0){
                    if(tabuleiro[linha][tempColuna] == '0' && (coluna-i < 10 && coluna-i >= 0)){ //Esquerda
                        tabuleiro[linha][tempColuna] = carrier;
                        tempColuna--;
                        erro = 0;
                    } else if(tabuleiro[linha][tempColuna+i] == '0' && (tempColuna+i < 10 && tempColuna+i >= 0)){
                        tabuleiro[linha][tempColuna+i] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempColuna = coluna;
                    }
                } else{
                    if(tabuleiro[linha][tempColuna] == 'C'){
                        tabuleiro[linha][tempColuna] = '0';
                        tempColuna--;
                    } else if(tabuleiro[linha][tempColuna+i] == 'C' && (tempColuna+i < 10 && tempColuna+i >= 0)) {
                        tabuleiro[linha][tempColuna + i] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
        if(axis == 1){ // Vertical
            for (int i = 0; i < 5; ++i) {
                if(tempLinha < 0) tempLinha = 0;
                if(erro == 0){
                    if(tabuleiro[linha-i][coluna] == '0' && (linha-i < 10 && linha-i >= 0)){ //Cima
                        tabuleiro[linha-i][coluna] = carrier;
                        if(i != 0) tempLinha--;
                        erro = 0;
                    } else if(tabuleiro[tempLinha+i][coluna] == '0' && (tempLinha+i < 10 && tempLinha+i >= 0)){
                        tabuleiro[tempLinha+i][coluna] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempLinha = linha;
                    }
                } else{
                    if(tabuleiro[linha-i][coluna] == 'C'){
                        tabuleiro[linha-i][coluna] = '0';
                        if(i != 0) tempLinha--;
                    } else if(tabuleiro[tempLinha+i][coluna] == 'C' && (tempLinha+i < 10 && tempLinha+i >= 0)) {
                        tabuleiro[tempLinha+i][coluna] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
    } while (erro == 1);
}

void gerarBattleship(char tabuleiro[10][10]){
    char carrier = 'B';
    int linha = 0, coluna = 0;
    int tempLinha = 0, tempColuna = 0, erro = 0, size = 4;
    do{
        erro = 0;
        size = 4;
        do{
            linha = gerarlinhaAleatorio();
            coluna = gerarColunaAleatorio();
            if(linha >= 10 || coluna >= 10) continue;
            if(tabuleiro[linha][coluna] == '0'){
                break;
            }
        } while (tabuleiro[linha][coluna] != 0);
        tempColuna = coluna;
        tempLinha = linha;
        int axis = gerarAxisAleatorio();
        if(axis != 1){  //Horizontal - Tá entre 0-1
            for (int i = 0; i < size; ++i) {
                if(tempColuna < 0) tempColuna = 0;
                if(erro == 0){
                    if(tabuleiro[linha][coluna-i] == '0' && (coluna-i < 10 && coluna-i >= 0)){ //Esquerda
                        tabuleiro[linha][coluna-i] = carrier;
                        if(i != 0) tempColuna--;
                        erro = 0;
                    } else if(tabuleiro[linha][tempColuna+i] == '0' && (tempColuna+i < 10 && tempColuna+i >= 0)){
                        tabuleiro[linha][tempColuna+i] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempColuna = coluna;
                    }
                } else{
                    if(tabuleiro[linha][coluna-i] == 'B'){
                        tabuleiro[linha][coluna-i] = '0';
                        if(i != 0) tempColuna--;
                    } else if(tabuleiro[linha][tempColuna+i] == 'B' && (tempColuna+i < 10 && tempColuna+i >= 0)) {
                        tabuleiro[linha][tempColuna + i] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
        if(axis == 1){ // Vertical
            for (int i = 0; i < size; ++i) {
                if(tempLinha < 0) tempLinha = 0;
                if(erro == 0){
                    if(tabuleiro[linha-i][coluna] == '0' && (linha-i < 10 && linha-i >= 0)){ //Cima
                        tabuleiro[linha-i][coluna] = carrier;
                        if(i != 0) tempLinha--;
                        erro = 0;
                    } else if(tabuleiro[tempLinha+i][coluna] == '0' && (tempLinha+i < 10 && tempLinha+i >= 0)){
                        tabuleiro[tempLinha+i][coluna] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempLinha = linha;
                    }
                } else{
                    if(tabuleiro[linha-i][coluna] == 'B'){
                        tabuleiro[linha-i][coluna] = '0';
                        if(i != 0) tempLinha--;
                    } else if(tabuleiro[tempLinha+i][coluna] == 'B' && (tempLinha+i < 10 && tempLinha+i >= 0)) {
                        tabuleiro[tempLinha+i][coluna] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
    } while (erro == 1);
}

void gerarDestroyer(char tabuleiro[10][10]){
    char carrier = 'D';
    int linha = 0, coluna = 0;
    int tempLinha = 0, tempColuna = 0, erro = 0, size = 3;
    do{
        erro = 0;
        size = 3;
        do{
            linha = gerarlinhaAleatorio();
            coluna = gerarColunaAleatorio();
            if(linha >= 10 || coluna >= 10) continue;
            if(tabuleiro[linha][coluna] == '0'){
                break;
            }
        } while (tabuleiro[linha][coluna] != 0);
        tempColuna = coluna;
        tempLinha = linha;
        int axis = gerarAxisAleatorio();
        if(axis != 1){  //Horizontal - Tá entre 0-1
            for (int i = 0; i < size; ++i) {
                if(tempColuna < 0) tempColuna = 0;
                if(erro == 0){
                    if(tabuleiro[linha][coluna-i] == '0' && (coluna-i < 10 && coluna-i >= 0)){ //Esquerda
                        tabuleiro[linha][coluna-i] = carrier;
                        if(i != 0) tempColuna--;
                        erro = 0;
                    } else if(tabuleiro[linha][tempColuna+i] == '0' && (tempColuna+i < 10 && tempColuna+i >= 0)){
                        tabuleiro[linha][tempColuna+i] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempColuna = coluna;
                    }
                } else{
                    if(tabuleiro[linha][coluna-i] == 'D'){
                        tabuleiro[linha][coluna-i] = '0';
                        if(i != 0) tempColuna--;
                    } else if(tabuleiro[linha][tempColuna+i] == 'D' && (tempColuna+i < 10 && tempColuna+i >= 0)) {
                        tabuleiro[linha][tempColuna + i] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
        if(axis == 1){ // Vertical
            for (int i = 0; i < size; ++i) {
                if(tempLinha < 0) tempLinha = 0;
                if(erro == 0){
                    if(tabuleiro[linha-i][coluna] == '0' && (linha-i < 10 && linha-i >= 0)){ //Cima
                        tabuleiro[linha-i][coluna] = carrier;
                        if(i != 0) tempLinha--;
                        erro = 0;
                    } else if(tabuleiro[tempLinha+i][coluna] == '0' && (tempLinha+i < 10 && tempLinha+i >= 0)){
                        tabuleiro[tempLinha+i][coluna] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempLinha = linha;
                    }
                } else{
                    if(tabuleiro[linha-i][coluna] == 'D'){
                        tabuleiro[linha-i][coluna] = '0';
                        if(i != 0) tempLinha--;
                    } else if(tabuleiro[tempLinha+i][coluna] == 'D' && (tempLinha+i < 10 && tempLinha+i >= 0)) {
                        tabuleiro[tempLinha+i][coluna] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
    } while (erro == 1);
}

void gerarSubmarine(char tabuleiro[10][10]){
    char carrier = 'S';
    int linha = 0, coluna = 0;
    int tempLinha = 0, tempColuna = 0, erro = 0, size = 3;
    do{
        erro = 0;
        size = 3;
        do{
            linha = gerarlinhaAleatorio();
            coluna = gerarColunaAleatorio();
            if(linha >= 10 || coluna >= 10) continue;
            if(tabuleiro[linha][coluna] == '0'){
                break;
            }
        } while (tabuleiro[linha][coluna] != 0);
        tempColuna = coluna;
        tempLinha = linha;
        int axis = gerarAxisAleatorio();
        if(axis != 1){  //Horizontal - Tá entre 0-1
            for (int i = 0; i < size; ++i) {
                if(tempColuna < 0) tempColuna = 0;
                if(erro == 0){
                    if(tabuleiro[linha][coluna-i] == '0' && (coluna-i < 10 && coluna-i >= 0)){ //Esquerda
                        tabuleiro[linha][coluna-i] = carrier;
                        if(i != 0) tempColuna--;
                        erro = 0;
                    } else if(tabuleiro[linha][tempColuna+i] == '0' && (tempColuna+i < 10 && tempColuna+i >= 0)){
                        tabuleiro[linha][tempColuna+i] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempColuna = coluna;
                    }
                } else{
                    if(tabuleiro[linha][coluna-i] == 'S'){
                        tabuleiro[linha][coluna-i] = '0';
                        if(i != 0) tempColuna--;
                    } else if(tabuleiro[linha][tempColuna+i] == 'S' && (tempColuna+i < 10 && tempColuna+i >= 0)) {
                        tabuleiro[linha][tempColuna + i] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
        if(axis == 1){ // Vertical
            for (int i = 0; i < size; ++i) {
                if(tempLinha < 0) tempLinha = 0;
                if(erro == 0){
                    if(tabuleiro[linha-i][coluna] == '0' && (linha-i < 10 && linha-i >= 0)){ //Cima
                        tabuleiro[linha-i][coluna] = carrier;
                        if(i != 0) tempLinha--;
                        erro = 0;
                    } else if(tabuleiro[tempLinha+i][coluna] == '0' && (tempLinha+i < 10 && tempLinha+i >= 0)){
                        tabuleiro[tempLinha+i][coluna] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempLinha = linha;
                    }
                } else{
                    if(tabuleiro[linha-i][coluna] == 'S'){
                        tabuleiro[linha-i][coluna] = '0';
                        if(i != 0) tempLinha--;
                    } else if(tabuleiro[tempLinha+i][coluna] == 'S' && (tempLinha+i < 10 && tempLinha+i >= 0)) {
                        tabuleiro[tempLinha+i][coluna] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
    } while (erro == 1);
}

void gerarBoat(char tabuleiro[10][10]){
    char carrier = 'P';
    int linha = 0, coluna = 0;
    int tempLinha = 0, tempColuna = 0, erro = 0, size = 2;
    do{
        erro = 0;
        size = 2;
        do{
            linha = gerarlinhaAleatorio();
            coluna = gerarColunaAleatorio();
            if(linha >= 10 || coluna >= 10) continue;
            if(tabuleiro[linha][coluna] == '0'){
                break;
            }
        } while (tabuleiro[linha][coluna] != 0);
        tempColuna = coluna;
        tempLinha = linha;
        int axis = gerarAxisAleatorio();
        if(axis != 1){  //Horizontal - Tá entre 0-1
            for (int i = 0; i < size; ++i) {
                if(tempColuna < 0) tempColuna = 0;
                if(erro == 0){
                    if(tabuleiro[linha][coluna-i] == '0' && (coluna-i < 10 && coluna-i >= 0)){ //Esquerda
                        tabuleiro[linha][coluna-i] = carrier;
                        if(i != 0) tempColuna--;
                        erro = 0;
                    } else if(tabuleiro[linha][tempColuna+i] == '0' && (tempColuna+i < 10 && tempColuna+i >= 0)){
                        tabuleiro[linha][tempColuna+i] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempColuna = coluna;
                    }
                } else{
                    if(tabuleiro[linha][coluna-i] == 'P'){
                        tabuleiro[linha][coluna-i] = '0';
                        if(i != 0) tempColuna--;
                    } else if(tabuleiro[linha][tempColuna+i] == 'P' && (tempColuna+i < 10 && tempColuna+i >= 0)) {
                        tabuleiro[linha][tempColuna + i] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
        if(axis == 1){ // Vertical
            for (int i = 0; i < size; ++i) {
                if(tempLinha < 0) tempLinha = 0;
                if(erro == 0){
                    if(tabuleiro[linha-i][coluna] == '0' && (linha-i < 10 && linha-i >= 0)){ //Cima
                        tabuleiro[linha-i][coluna] = carrier;
                        if(i != 0) tempLinha--;
                        erro = 0;
                    } else if(tabuleiro[tempLinha+i][coluna] == '0' && (tempLinha+i < 10 && tempLinha+i >= 0)){
                        tabuleiro[tempLinha+i][coluna] = carrier;
                        erro = 0;
                    } else{
                        erro = 1;
                        size = i;
                        i = -1;
                        tempLinha = linha;
                    }
                } else{
                    if(tabuleiro[linha-i][coluna] == 'P'){
                        tabuleiro[linha-i][coluna] = '0';
                        if(i != 0) tempLinha--;
                    } else if(tabuleiro[tempLinha+i][coluna] == 'P' && (tempLinha+i < 10 && tempLinha+i >= 0)) {
                        tabuleiro[tempLinha+i][coluna] = '0';
                    }
                    if(i == size-1) break;
                }
                if(i == size-1) erro = 0;
            }
        }
    } while (erro == 1);
}