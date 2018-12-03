function [x,y,D] = knotsAdaptiveSpline(k,a,b, epsl)
%% Descri��o
% Esta fun��o est� respons�vel pela sele��o dos n�s �timos para a
% interpola��o de uma fun��o f para um algoritmo adaptativo. Na 
% verdade, como indicado no relat�rio usaremos uma aproxima��o para
% o majorante do erro. Verificamos que para apenas 2 tro�os inicais 
% a aproxima��o � v�lida o suficiente para a aplica��o da aproxima��o. 
% � claro que para fun��es mais ex�ticas � necess�rio come�ar com um 
% n�mero de tro�os mais adequado 

%% Itera��o
    % Criar parti��o inicial com 2 tro�os e pontso interiores 
    % auxiliares
    x_ = [a:(b-a)/8:b];
    y_ = funChoice(x_,k,0);
    
    % Criar parti��o inicial com 2 tro�os sem os pontso auxilires
    x = [a:(b-a)/2:b];
    y = [y_(1) y_(5) y_(9)];
    
    % soma ponderada dos pontos usada para calcular a estimativa da 
    %quarta derivada em ambos os tro�os
    d4Est1 = estimateD4(1,y_);
    d4Est2 = estimateD4(5,y_);
    
    % estimativa do majorante do erro
    error1 = abs((3125/385)*d4Est1);
    error2 = abs((3125/385)*d4Est2);
    
    % Verificar se cada um dos tro�os induz um erro superior a epsl
    % Nesse caso divide o intervalo em dois
    if (error2 > epsl)
        [x,y,x_,y_] = divideInterval(x,2,y,epsl,k,x_,y_);
    end
    if(error1 > epsl)
        [x,y,x_,y_] = divideInterval(x,1,y,epsl,k,x_,y_);
    end
    
    % calcular a derivada da fun��o nos n�s extremos a partir 
    % de diferen�as finitas 
    D = derivativesExterior(x_,y_);
        
end

%% Fun��es auxiliares

function [x,y,x_,y_] = divideInterval(x,idx,y,epsl,k,x_,y_)
% Fun��o recursiva que divide um intervalo dado em dois e verifica se 
% nesses dois novos intervalos o erro cometido � inferior a epsl. Se 
% n�o for, a fun��o invoca-se a ela mesma at� que o erro seja 
% inferior a epsl
% Recebe como argumentos: 
% - os vetores de n�s x e valores respetivos da fun��o
% - os vetores de n�s auxiliares e respetivos valores da fun��o
% - o �ndice no vetor x do primeiro n� no extremo que se pretende 
% dividir
% - k a fun��o usada
% - epsl o limite maximo do erro
                          
    
    % Calcular os pontos auxiliares em cada intervalo 
    [x,y,x_,y_] = updateSupportVectors(x,y,x_,y_,idx,k);
  
    % Calculate error for new interval
    h = zeros(1,size(x,2)-1);
    for i = 2:size(x,2)
       h(i-1) = x(i)-x(i-1);
    end
    
    % Soma ponderada dos pontos usada para calcular a estimativa 
    % da quarta derivada em ambos os tro�os
    d4Est1 = estimateD4(find(abs(x_-x(idx))<eps),y_);
    d4Est2 = estimateD4(find(abs(x_-x(idx+1))<eps),y_);
   
    % Aproximar o erro
    error1 = (3125/385)*d4Est1;
    error2 = (3125/385)*d4Est2;
    
    if (abs(error2) > epsl) % verifica se o erro � j� inferior a epsl
        [x,y,x_,y_] = divideInterval(x,idx+1,y,epsl,k,x_,y_);
    end
    if (abs(error1) > epsl)
        [x,y,x_,y_] = divideInterval(x,idx,y,epsl,k,x_,y_);
    end
end

function [x,y,x_,y_] = updateSupportVectors(x,y,x_,y_,idx,k)
% Fun��o que � chamada quando um intervalo � dividido por forma a 
% atualizar os valores dos vetores de n�s e de n�s auxiliares na 
% divis�o do tro�o cujo �ndice do primeiro n� � idx
% Recebe como argumentos:
% - os vetores de n�s x e valores respetivos da fun��o
% - os vetores de n�s auxiliares e respetivos valores da fun��o
% - o �ndice no vetor x do primeiro n� no extremo que se pretende 
% dividir
% - k a fun��o usada
    
    % Introduzir um n� no vetor x
    x = [x(1:idx) (x(idx)+x(idx+1))/2 x(idx+1:end)];
    % Introduzir o valor respetivo da fun��o no novo n�. � de notar
    % que n�o � necess�rio calcular esse valor novamente uma vez que
    % � um dos n�s auxiliares
    y = [y(1:idx) y_(abs(x_-(x(idx+2)+x(idx))/2)< eps) y(idx+1:end)];
    
    % Determinar o �ndice de x_ do primeiro n� do tro�o considerado 
    idx_ = find(abs(x_-x(idx))<eps);
    
    % Determinar os novos n�s auxiliares
    for i = 1:4
        x_ = [x_(1:idx_) (x_(idx_)+x_(idx_+1))/2 x_(idx_+1:end)];
        y_ = [y_(1:idx_) funChoice((x_(idx_)+x_(idx_+2))/2,k,0)...
                                                 y_(idx_+1:end)];
        idx_ = idx_ +2;
    end
    
end

function d4Est = estimateD4(idx_,y_)
%Fun��o que dado o �ndice do vetor y_ do primeiro n� do tro�o 
% considerado retorna a soma ponderada que � usada para aproximar a
% quarta derivada no tro�o
    d4Est = y_(idx_)-4*y_(idx_+1)+6*y_(idx_+2)-4*y_(idx_+3)+...
                                                        y_(idx_+4);
end

function D = derivativesExterior(x,y)
% Fun��o que utiliza diferencas finitas para calcular um valor 
% aproximado para a primeira derivada nos n�s extremos a partir 
% de 5 pontos
    D = zeros(1,2);
    D(1) = ((-50*y(1)+96*y(2)-72*y(3)+32*y(4)-6*y(5))/...
                                                (24*(x(2)-x(1))));
    D(2) = ((50*y(end)-96*y(end-1)+72*y(end-2)-...
                    32*y(end-3)+6*y(end-4))/(24*(x(end)-x(end-1))));
end

