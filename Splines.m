function Splines()
%% Descri��o
% � a fun��o que dever� ser executada pelo utilizador
% Fun��o encarregue de toda a intera��o com o utilizador. 
% � a fun��o que permite escolher a opera��o a efetura e os 
% parametros desejados.

%% Menu inicial
    fprintf("Bem vindo! ");    
    fprintf("Selecione das alternativas abaixo a desejada:\n");
    fprintf("1 - Interpola��o de uma fun��o e suas derivadas\n");
    fprintf("2 - Estudar a ordem de converg�ncia do erro\n");
    fprintf("3 - Interpolar um modo de vibra��o de uma viga\n");
    fprintf("4 - Interpola��o adaptativa de uma fun��o\n");
    fprintf("5 - Desenhar o spline guardado num ficheiro\n");
    fprintf("Escolha: ");
    
    % Ler a escolha e verificar a a sua validade
    escolha =str2double(input('','s'));
    while(isnan(escolha) || not(escolha == 1 || escolha ==2 || escolha ==3 || escolha == 4 || escolha ==5))
        fprintf('Op��o inv�lida. Escolha:');
        escolha = str2double(input('','s'));
    end
    
    % Escolher a opera��o a executar consoanete a escolha do utilizador
    switch(escolha)
        case 1
            % Por forma a evitar usar calculo simb�loco apenas �
            % poss�vel representar a primeira e segunda derivada do
            % spline sem an�lise do erro
            interpolarFuncao();
        case 2
            erro();
        case 3
            vigaVibracao();
        case 4
            adaptativo();
        case 5
          fprintf("Digite o nome do ficheiro para extrair os dados: ");
          filename = input('','s');
          plotSplineFromTxt(filename);
    end

end

%% Fun��es auxiliares

function interpolarFuncao()
% Fun��o que recolhe todos os par�metros necess�rios para 
% interpolar uma fun��o e executa o comando
     d = selecinarFuncaoInteresse();
     k = selecionarFuncao(0);
     s = selecionarSpline();
     [a,b] = selecionarIntervalo();
     n = selecionarNtrocos(s);
     filenameS = saveSplineFileName();
     splineUniform(s-1,k,a,b,n,d,1,filenameS);
end

function erro()
% Fun��o que recolhe todos os par�metros necess�rios para fazer
% a an�lise do erro em fun��o do espa�amento. Em particular, 
% estudar os declive do gr�fico log(Emax) vs log(h) por forma a 
% estudar a ordem de converg�ncia do spline escolhido
    k = selecionarFuncao(1);
    s = selecionarSpline();
    [a,b] = selecionarIntervalo();
    errorAnalysis(s-1,k,a,b);
end

function vigaVibracao()
% Fun��o que pede o nome do ficheiro onde est�o guardados os 
% dados da viga e executa a interpola��o desses dados.
    fprintf("Digite o nome do ficheiro para extrair os dados: ");
    filename = input('','s');
    filenameS = saveSplineFileName;
    beam(filename, filenameS);
end

function adaptativo()
    k = selecionarFuncao(0);
    [a,b] = selecionarIntervalo();
    epsl = limiteErro();
    splineAdaptive(k,a,b,epsl,1);
end

function k = selecionarFuncao(u)
% Fun��o que permite ao utilizador selecionar uma fun��o das j�
% predefinidas ou introduzir uma nova fun��o.
% Recebe u que para: u = 1 o utilizador n�o pode definir uma fun��o
%                  : u = 0 o utilizador pode definir uma fun��o 
    fprintf("\nSelecione a fun��o a interpolar:\n");
    fprintf("1 - log(1+x)\n");
    fprintf("2 - 1/(1+25*x^2)\n");
    fprintf("3 - sin(x^2)\n");
    fprintf("4 - tanh(x)\n");
    fprintf("5 - sin(pi*x)\n");
    if(u==0)
        fprintf("6 - Introduzir outra fun��o\n");
    end
    fprintf("Escolha: ");
    
    k =str2double(input('','s')); %verificar aa validade da escolha
    while(isnan(k) || not(k == 1 || k ==2 || k ==3 || k == 4 || k == 5 || k == 6-u))
        fprintf('Op��o inv�lida. Escolha:');
        k = sscanf(input('','s'), "%d");
    end
    % se o utilizador escolher a fun��o a vari�vel k passa a ser
    % um 'function_handle' que a fun��o funChoice consiguir� 
    %intrepertar corretamente
    if(k == 6) 
         fprintf("Introduzir fun��o de vari�vel x: ");
         k = str2func(['@(x)' input('','s')]);  
    end
end

function s = selecionarSpline()
% Fun��o que permite selecionar o tipo de spline interpolador

    fprintf("\nSelecione o tipo de spline a usar:\n");
    fprintf("1 - Natural\n");
    fprintf("2 - Completo\n");
    fprintf("3 - Not-a-Knot\n");
    fprintf("Escolha: ");
    
    s =sscanf(input('','s'),"%d");
    % verificar a avalidade da escolha
    while(isnan(s) || not(s == 1 || s ==2 || s ==3 || s == 4))
        fprintf('Op��o inv�lida. Escolha:');
        s =sscanf(input('','s'),"%d");
    end
end

function [a,b] = selecionarIntervalo()
% Fun��o que permite selecionar o intervalo no qual ser� feita a
% interpola��o
    fprintf("\n� imperativo que a fun��o escolhida esteja definida no intervalo selecionado.\n");
    fprintf("Defina o intervalo a interpolar na forma a,b: ");

    while true % verificar a avalidade do intervalo
        A = sscanf(input('','s'),"%f,%f");
        % verificar que a amplitude do intervalo � superior a 0.03
        if(max(size(A)) == 2 && A(2)> A(1) + 0.03)
            break;
        end
        fprintf("Inv�lido. Intervalo na forma a,b: ");
    end
    a = A(1);
    b = A(2); 
end

function n = selecionarNtrocos(s)
% Fun��o que permite selecionar o n�mero de tro�os a usar na 
% interpola��o
    fprintf("N�mero de tro�os: ");
     while true %verificara a validade ad escolha
        n = sscanf(input('','s'),"%d");
        if(max(size(n)) == 1 && n>0 && not(n<3 && s == 3))
          break;
        elseif(n<3 && s == 3)
          % fprintf em comandos separados por uma questao de
          % formata��odo c�digo
          fprintf("O spline Not-a-Knot necessita de no m�nimo 3 tro�os.");
          fprinf(" N�mero de tro�os: ");
        else
          fprintf("Inv�lido. Intervalo na forma a,b: ");
        end
        
     end
end

function d = selecinarFuncaoInteresse()
% Fun��o que permite selecionara os gr�ficos que predende estudar
    fprintf("\nSe decidir estudar derivadas da fun��o poder�, apenas, comparar o valor obtido com o real se optar por uma fu��o predefinida");
    fprintf("\nSelecione o que pretende estudar:\n");
    fprintf("1 - Fun��o\n");
    fprintf("2 - Fun��o e sua 1� derivada\n");
    fprintf("3 - Fun��o, 1� e 2� derivadas\n");
    fprintf("Escolha: ");
    
    s =sscanf(input('','s'),"%d");
    % verificar a a validade da escolha
    while(isnan(s) || not(s == 1 || s ==2 || s ==3 ))
        fprintf('Op��o inv�lida. Escolha:');
        s =sscanf(input('','s'),"%d");
    end
    
    if(s == 1)
        d = [1 0 0];
    elseif(s == 2)
        d = [1 1 0];
    else
        d = [1 1 1];
    end
end

function filenameS = saveSplineFileName()
%Fun��o que permite ao utilizador introduzir o nome do ficheiro em que
%guardar� os dados do spline interpolador
    % fprintf em comandos separados por uma questao de formata��o
    % do c�digo
    fprintf("Se n�o pretender gurdar o spline carregue em ENTER, caso ");
    fprintf("contr�rio digite o nome do ficheiro em que pretende gurdar: ");
    filenameS = input('','s');
end


function epsl = limiteErro()
    while true %verificara a validade do erro
        fprintf("Introduza o limite do erro desejado: ");
        epsl = sscanf(input('','s'),"%f");
        if(epsl>10*eps)
            break;
        end
        fprintf("Inv�lido. Limite do erro: ");
    end
end 



