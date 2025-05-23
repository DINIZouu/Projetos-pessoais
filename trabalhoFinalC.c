#include <stdio.h>

typedef struct {
    char nomeproduto[30];
    float valor;
    int estoque;
} produto;

int main() {
    char nome[50];
    printf("Digite seu nome: ");
    scanf(" %[^\n]", nome);

    produto produtos[10];
    int quantidade, i;

    printf("%s, quantos produtos deseja cadastrar? (até 10 produtos): ", nome);
    scanf("%d", &quantidade);

    if (quantidade > 10) {
        printf("Limite de produtos excedido.\n");
        return 1;
    }

    for (i = 0; i < quantidade; i++) {
        printf("\nProduto %d:\n", i + 1);
        printf("Nome: ");
        scanf(" %[^\n]", produtos[i].nomeproduto);
        printf("Valor: ");
        scanf("%f", &produtos[i].valor);
        printf("Estoque: ");
        scanf("%d", &produtos[i].estoque);
    }

    FILE *arquivo = fopen("compras.csv", "w");
    if (arquivo == NULL) {
        printf("Erro ao criar o arquivo!\n");
        return 1;
    }

    fprintf(arquivo, "Produto,Valor Unitario,Quantidade Comprada,Subtotal\n");

    int opcao, qtd_compra, total_comprado = 0;
    float total_valor = 0.0;

    printf("\n%s, vamos às compras!\n", nome);
    do {
        printf("\nProdutos disponíveis:\n");
        for (i = 0; i < quantidade; i++) {
            printf("%d - %s | R$%.2f | Estoque: %d\n", i + 1,
                   produtos[i].nomeproduto, produtos[i].valor, produtos[i].estoque);
        }

        printf("\nDigite o número do produto que deseja comprar (0 para finalizar): ");
        scanf("%d", &opcao);

        if (opcao == 0) {
            break;
        }

        if (opcao < 1 || opcao > quantidade) {
            printf("Produto inválido.\n");
            continue;
        }

        printf("Quantas unidades deseja comprar de %s? ", produtos[opcao - 1].nomeproduto);
        scanf("%d", &qtd_compra);

        if (qtd_compra <= produtos[opcao - 1].estoque) {
            produtos[opcao - 1].estoque -= qtd_compra;
            total_comprado += qtd_compra;
            float subtotal = qtd_compra * produtos[opcao - 1].valor;
            total_valor += subtotal;

            fprintf(arquivo, "%s,R$%.2f,%d,R$%.2f\n",
                    produtos[opcao - 1].nomeproduto,
                    produtos[opcao - 1].valor,
                    qtd_compra,
                    subtotal);

            printf("Compra registrada no arquivo!\n");
        } else {
            printf("Estoque insuficiente! Só temos %d unidades.\n", produtos[opcao - 1].estoque);
        }

    } while (1);

    printf("\nResumo da compra de %s\n", nome);
    printf("Total de produtos comprados: %d\n", total_comprado);
    printf("Valor total da compra: R$%.2f\n", total_valor);

    fprintf(arquivo, "\nTotal Comprado,,%d,R$%.2f\n", total_comprado, total_valor);
    fclose(arquivo);
    printf("\nArquivo 'compras.csv' salvo com sucesso!\n");

    return 0;
}
