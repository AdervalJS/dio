programa
{
	inclua biblioteca Arquivos
	inclua biblioteca Texto
	inclua biblioteca Util

	inclua biblioteca Objetos
	inclua biblioteca Tipos
	inclua biblioteca Matematica
	inclua biblioteca Calendario

	cadeia PASTA_DO_USUARIO = Util.obter_diretorio_usuario()
	inteiro ANO_ATUAL = Calendario.ano_atual()
	cadeia PASTA_DO_APP = PASTA_DO_USUARIO + "\\vendas\\" + ANO_ATUAL + "\\" 
	cadeia ARQUIVOS_DE_VENDAS[12] = {"","","","","","","","","","","",""}
	

	funcao criarArquivo(cadeia mes){
		cadeia novoArquivo = PASTA_DO_APP + mes

		inteiro endereco = Arquivos.abrir_arquivo(novoArquivo, 2)
		Arquivos.fechar_arquivo(endereco)
	}
	
	funcao adicionarVendas(cadeia mes){
		real preco = 0.0
		cadeia nome = ""
		caracter sair
		inteiro diaDoMes = Calendario.dia_mes_atual()
	
		faca {
			escreva("Qual o nome do produto?")
			leia(nome)
			escreva("Qual o preço do produto?")
			leia(preco)
	
			inteiro endereco = Arquivos.abrir_arquivo(PASTA_DO_APP + mes, 2)
			Arquivos.escrever_linha( nome + " = " + preco  + " -> " + diaDoMes, endereco)
	
			Arquivos.fechar_arquivo(endereco)
	
			escreva("\nVocê quer adicionar mais produtos? s/n: ")
			leia(sair)	
		}enquanto(sair != 'n')

		limpa()
	}

	funcao cadeia selecionarLinha(cadeia arquivo, inteiro linhaSelecionada){
		cadeia conteudoDaLinha = ""
		inteiro endereco = Arquivos.abrir_arquivo(PASTA_DO_APP + arquivo, 0)
		inteiro numeroDaLinha = 1
		
		 enquanto(conteudoDaLinha == ""){
			cadeia linha = Arquivos.ler_linha(endereco)

			se(linha != "") {
				se(numeroDaLinha == linhaSelecionada){
					conteudoDaLinha = linha
				}
				
				numeroDaLinha++
			}

		}

		Arquivos.fechar_arquivo(endereco)

		retorne conteudoDaLinha
	}

	funcao removerVendas(cadeia mes, inteiro linhaSelecionada){
		cadeia conteudoDaLinha = selecionarLinha(mes, linhaSelecionada)
		
		Arquivos.substituir_texto(PASTA_DO_APP + mes, conteudoDaLinha, "", verdadeiro)
	}

	funcao escreverVendas(cadeia mes){
		inteiro endereco = Arquivos.abrir_arquivo(PASTA_DO_APP + mes, 0)

		escreva("\n")

		logico fimDoArquivo = falso
		inteiro numeroDaLinha = 1
		real totalDeVendasDoMes = 0.0
		
		 enquanto(nao Arquivos.fim_arquivo(endereco)){
			cadeia linha = Arquivos.ler_linha(endereco)

			se(linha != "") {
				inteiro posicaoDoSinalDeIgualdade = Texto.posicao_texto("=", linha, 0) + 2
				inteiro totalDePosicoes = Texto.numero_caracteres(linha)

				cadeia preco = Texto.extrair_subtexto(linha, posicaoDoSinalDeIgualdade, totalDePosicoes)

				totalDeVendasDoMes = totalDeVendasDoMes + Tipos.cadeia_para_real(preco)
				
				escreva(numeroDaLinha + "# -> " + linha + "\n")	
		 		numeroDaLinha++
			}
		}

		escreva("\nTotal De Vendas em " + mes + " -> " + totalDeVendasDoMes + "\n")

		Arquivos.fechar_arquivo(endereco)
	}

	funcao editarMes(cadeia mes){
		logico fecharDialogo = falso
		
		enquanto(nao fecharDialogo){
			limpa()
			escreva("Suas vendas de " + mes + "\n")
			
			escreverVendas(mes)

			inteiro resposta = 0
			escreva("\nO que você quer fazer? 0(Sair) 1(Adicionar) 2(Remover): ")
			leia(resposta)

			se(resposta == 0){
				fecharDialogo = verdadeiro
			}

			se(resposta == 1){
				adicionarVendas(mes)
			}

			se(resposta == 2){
				inteiro linha = 0
				escreva("\nDigite o numero da venda: ")
				leia(linha)
				removerVendas(mes, linha)
			}
		}
		
		limpa()
	}

	funcao inteiro removerEspacosVaziosDaMatriz(cadeia arquivos[]){
		inteiro quantidadeDeArquivos = 0
		
		para(inteiro i=0; i < Util.numero_elementos(arquivos); i++){
			cadeia arquivoAtual = arquivos[i]
			inteiro numeroDoArquivoAtual = i + 1
			
			se(arquivoAtual != ""){
				quantidadeDeArquivos = numeroDoArquivoAtual
			}
		}

		retorne quantidadeDeArquivos
	}

	funcao logico perguntarSeOsMesesSeraoEditados (){
		logico editarArquivo = falso
		logico fecharDialogo = falso

		enquanto(nao fecharDialogo){
			caracter resposta = 'i'
			escreva("Há vendas salvas, quer editar uma dessas vendas? s/n ")
			leia(resposta)

			escreva("\n")
	
			se(resposta == 's'){
				editarArquivo = verdadeiro
				fecharDialogo = verdadeiro
			} 
			
			se (resposta == 'n') {
				fecharDialogo = verdadeiro
			}
		}

		retorne editarArquivo
	}

	funcao selecionarMesParaEdicao(){
		logico fecharDialogo = falso
		inteiro quantidadeDeArquivos = removerEspacosVaziosDaMatriz(ARQUIVOS_DE_VENDAS)
		
		enquanto(nao fecharDialogo){
			para(inteiro i=0; i < quantidadeDeArquivos; i++){
				cadeia arquivoAtual = ARQUIVOS_DE_VENDAS[i]
				inteiro numeroDoArquivoAtual = i + 1
				
				escreva(numeroDoArquivoAtual + " -> " +  arquivoAtual + "\n")
			}
			
			inteiro arquivoSelecionado = 0
			escreva("\nDigiti o numero do mês que será editado: 0(Sair): ")
			leia(arquivoSelecionado)

			se(arquivoSelecionado > 0 e arquivoSelecionado <= quantidadeDeArquivos) {
				editarMes(ARQUIVOS_DE_VENDAS[arquivoSelecionado - 1])
			}

			se(arquivoSelecionado == 0){
				fecharDialogo = verdadeiro
			}

		}	
	}

	funcao inteiro verificarSeHaVendas(){
		Arquivos.criar_pasta(PASTA_DO_APP)
		
		Arquivos.listar_arquivos(PASTA_DO_APP, ARQUIVOS_DE_VENDAS)

		inteiro quantidadeDeArquivos = removerEspacosVaziosDaMatriz(ARQUIVOS_DE_VENDAS)
		
		retorne quantidadeDeArquivos
	}

	funcao cadeia selecionarMes(){
		cadeia meses[12] = {"janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","setembro","outubro","Novembro","Dezembro"}
		inteiro mesSelecionado = 0
		cadeia mes = ""

		para(inteiro i=0; i < Util.numero_elementos(meses); i++){
			inteiro  numeroDoMes = i + 1
			escreva(numeroDoMes + "# -> " + meses[i] + "\n")
		}

		escreva("\nEm que mês as vendas foram feitas? 0 (Sair):")
	
		leia(mesSelecionado)

		se(mesSelecionado > 0){
			mesSelecionado = mesSelecionado - 1
			mes = meses[mesSelecionado]
			
			criarArquivo(mes)
		}
		
		retorne mes
	}
	
	funcao inicio()
	{
		inteiro quantidadeDeArquivos = verificarSeHaVendas()

		se(quantidadeDeArquivos > 0) {
			
			logico editarArquivo = perguntarSeOsMesesSeraoEditados()

			se(editarArquivo) {
				selecionarMesParaEdicao()
			}
			
			limpa()
		}

		caracter continuar = 's'

		faca{
			cadeia mes = selecionarMes()

			se(mes != "") {
				adicionarVendas(mes)	
			}

			escreva("Você quer adicionar mais um mês de vendas? s/n: ")
			leia(continuar)

		}enquanto(continuar != 'n')
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 628; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = {posicaoDoSinalDeIgualdade, 92, 12, 25};
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */