function E = splineAdaptive(k,a,b,epsl,PlotGraph)
%% Descri��o
% A fun��o splineAdative interpola uma fun��o dada pela fun��o 
% splineFunction atrav�s de um spline completo, adaptativamente. Dito 
% por outras palavras, esta fun��o interpola uma fun��o num conjunto 
% �timo de n�s e menor poss�vel de forma a que o erro seja inferior 
% a epsl.
% A fun��o recebe como input:
%   -k: a fun��o a interpolar
%   -a,b: os extremos do intervalo a interpolar
%   -epslon: o eero m�ximo permitido na interpola��o
%   -PlotGraph:
%       -0: N�o fazer o plot da fun��o interpolada, do spline 
% interpolador
%           nem dos n�s usados para a interpola��o
%       -1: Apesentar os resultados em um gr�fico
% Esta fun��o retorna o valor absoluto do maior erro cometido na
% interpola��o.

% Fun��es Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

%% Constantes
    % n�mero de pontos usados para o tracar o gr�fico do spline
    nG = 1000; 

%% Calcular n�s
    % A fun��o knotsAdaptiveSpline seleciona um conjunto de pontos
    % �timo para interpolar a fun��o no intervalo a,b e com erro 
    % inferior a epsl
    [x,y,D] = knotsAdaptiveSpline(k,a,b,epsl);
    
    
%% Obter o vetor M
% O vetor M, o vetor com o valor das segundas derivadas do spline 
%interpolador em cada um dos n�s
    
    % Resolver o sistema para cada tipo de spline
   
    % obter as derivadas da fun��o interpolada nos n�s extremos
    M = splineClampedAdaptive(x,y,D);
    
%% Criar gr�fico
    % instanciar o vetor com os x dos pontos do gr�fico
    xG = [a:(b-a)/nG:b]; 
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos tra�ar o gr�fico a partir da fun��o splineFunction
    yGs = splineFunctionAdaptive(xG,x,y,M);
    % calcular os valores da fun��o interpolada nos pontos x do gr�fico
    yGf = funChoice(xG,k,0); 
    
    if(PlotGraph)
        figure;
        plot(xG,yGs); % plot do spline interpolador 
        hold on;
        scatter(x,y); % plot da fun��o interpolada
        plot(xG,yGf); % plot dos n�s usados para a interpola��o
        hold off;
    end
    
%% An�lise de erro
% An�lise do erro cometido na interpola��o e c�lculo de E
    % vetor do erro de cada ponto calculado para o gr�fico
    yGe = yGf-yGs; 
    % valor absoluto do maior dos erros cometidos na interpola��o
    E = max(abs(yGe)); 
    if(PlotGraph)
        figure;
        plot(xG,yGe); % plot da fun��o de erro na interpola��o
        hold off;
        % Print do valor do erro m�ximo na command window
        fprintf("Erro m�ximo na interpola��o �: %f\n", E);
    end
   
    
end
