#!/usr/bin/env bash

#-------------------------------------------------------------------------|
#                           Pressao arterial                              |
#                                                                         |
#          Erasmo Cardoso                                                 |
#-------------------------------------------------------------------------|

#=========================================================================|
#                Teste de verificação de dados e Variaveis

pressao_texto="pressao.txt" # cria arquivo de dados
data=$(date +%D-%H:%M) # data e hora na variavel
dialog=$(which dialog) # verifica comando dialog

#================Verificações===============================================

if [ -z "$dialog" ]; then clear ; echo "O comando ( dialog ) não esta instalado vc devera instala-lo  \
 para poder excultar o programa se for debian ou derivado execulte apt install dialog, verifique a sua \
 distribuição linux"; exit 1;
fi 

[[ ! -e "$pressao_texto" ]] &&  > "$pressao_texto" echo "===============Arquivo de Dados================" \
>> "$pressao_texto";

#---------Banco de dados------------
source /pressao.txt

#-------------------------------------------------------------------------|
#                           Menu
function menu_pressao(){


while true ; do
menu=$(                                                \
dialog  --stdout                                       \
	--title "Menu Pressão Arterial"                \
	--menu  "Controle de Pressão arterial"         \
	0 0 3                                          \
	'1' 'Registrar Pressão'		               \
	'2' 'Ver Registro'                             \
	'3' 'Sair' 
	
)	
case "$menu" in
	1) pressao_prog   ;;
	2) pressao_medida ;;
	3) dialog --sleep 4  --infobox "    Obrigado por utilizar ass. Erasmo cardoso"  3 50; clear; exit 0;; 
	*) dialog --sleep 4  --infobox "    Obrigado por utilizar ass. Erasmo cardoso"  3 50; clear; exit 1;;
esac
done
}

#==============================================================================|
# Marcar pressão em arquivo
function pressao_prog(){
nome_pressao=$(                                       \
	dialog  --stdout                              \
		--inputbox "Digite seu nome: "        \
		0 0                                   \
)
[[ "$?" = "1" ]] && menu_pressao ;

registro_maxima=$(                                    \
	dialog  --stdout			      \
		--inputbox "Digite pressão maxima: "  \
		0 0				      \	
)
[[ "$?" = "1" ]] && pressao_prog ;

registro_minima=$(                                    \
	dialog	--stdout	 		      \
		--inputbox "Digite pressão minima: "  \
		0 0                                   \
)
[[ "$?" = "1" ]] && pressao_prog ;	

#====================Verificar se esta correto=========
	(dialog \
               --cr-wrap                             \
               --sleep 5                             \
               --title 'Dados Armazenados'           \
               --infobox "                
                                
                    Os Dados informados foram
                
                $nome_pressao
                _______________________________     
                
                Maxima: $registro_maxima
                Minima: $registro_minima
                
    
                       Voltando ao Menu
                
                
                " 0 0                               \
                --and-widget                        \
                --yesno 'Dados corretos ?' 0 0      \
)                

[[ "$?" = "1" ]] && pressao_prog ;

#=========================Gravar em arquivo=============	
	
echo -e " Em, ${data},${nome_pressao^^} registrou a pressao de${registro_maxima}/${registro_minima}." >> "$pressao_texto";

menu_pressao
}

#======================================================================|
# Verificar pressao ja medida

function pressao_medida(){
nome_ver=$(                                                           \
	dialog  --stdout 				              \
		--inputbox "Digite seu nome para ver                  \
		 a pressão ja medida:"                                \
		0 0                                                   \
		
		result=$(grep -i "$nome_ver" "$pressao_texto")
)
[[ "$?" = "1" ]] && pressao_medida ;

result=$(grep -i "$nome_ver" "$pressao_texto")
						
(dialog 							     \
	 --title "Dados Salvos"					     \
	 --msgbox 						     \
	 "
	 	Arquivados das mediçoes de $nome_ver
	               	
	 $result"					             \
	 0 0       )   
}

#============Inicio============

menu_pressao




