function E = splineUniform(s,k,a,b,n,d,PlotGraph,filenameS)
%% Descri��o
% A fun��o splineUniform interpola uma fun��o dada pela fun��o 
% splineFunction atrav�s de um spline: 
%                       - Natural para s=0
%                       - Completo para s=1
%                       - Not a Knot para s=2
% A fun��o recebe como input:
%   -s: o tipo de spline a usar
%   -k: a fun��o a interpolar
%   -a,b: os extremos do intervalo a interpolar
%   -n: n�mero de tro�os a usar na interpola��o
%   -d: vetor 1x3 que contem a informa��o da fun��o ou derivadas
% de interesse
%   i.e. d(1)=1 significa fazer o estudo e gr�fico para a 
% fun��o e 0 o oposto
%        d(2)=1 significa fazer o estudo e gr�fico para a 
% primeira derivada e 0 o oposto etc
%   -PlotGraph:
%       -0: N�o fazer o plot da fun��o interpolada, do spline 
% interpolador nem dos n�s usados para a interpola��o
%       -1: Apesentar os resultados em um gr�fico
% Esta fun��o retorna o valor absolto do maior erro cometido na
% interpola��o, E. E vai ser um vetor de dimens�o igual ao n�mero 
% de 1s em d

% Fun��es Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

%% Constantes
% n�mero de pontos usados para o tracar o gr�fico do spline
    nG = 1000; 

%% Iniciar n�s
    h = (b-a)/n; % calcular o espa�amento (uniforme)
    x = [a:h:b]; % instanciar o vetor com os x dos n+1 n�s
    % instanciar o valores de y correspondes a cada um dos n�s
    y = funChoice(x,k,0);

%% Obter o vetor M
% O vetor M, o vetor com o valor das segundas derivadas do spline 
%interpolador em cada um dos n�s, � obtido de forma diferente 
% consoante o tipo de spline que usamos para interpolar a fun��o k
    
    % Resolver o sistema para cada tipo de spline
    switch s
        case 0 % spline natural
            M = splineNatural(n,h,y); 
        case 1 %spline completo
            % obter as derivadas da fun��o interpolada nos n�s extremos
            D = funChoice(x,k,1); 
            M = splineClamped(n,h,D,y);
        case 2 % spline not a knot
            M = splineNotAKnot(n,h,y);
    end
    
%% Criar gr�fico da fun��o, suas derivadas, e erros

    xG = [a:(b-a)/nG:b]; % instanciar o vetor com os x dos pontos
    % do gr�fico calcular os valores do spline interpolador nos 
    % pontos x onde pretendemos tra�ar o gr�fico a partir da fun��o 
    % splineFunction
    
    E = [];
    
    if (d(1) == 1)
        yGs = splineFunction(xG,x,y,M);
        % calcular os valores da fun��o interpolada para os pontos
        % x do gr�fico
        yGf = funChoice(xG,k,0);
        % vetor do erro de cada ponto calculado para o gr�fico
        yGe = yGf-yGs; 
        E = [E max(abs(yGe))]; 
    end
    
    if (d(2) == 1)
        yGsD = splineFunctionD(xG,x,y,M);
        % calcular os valores da derivada da fun��o para os pontos
        %x do gr�fico
        if(~isa(k, 'function_handle'))
            yGfD = funChoice(xG,k,2);
            % vetor do erro de cada ponto calculado para o gr�fico
            yGeD = yGfD-yGsD; 
            E = [E max(abs(yGeD))];
        end
    end
    
    if (d(3) == 1)
        yGsDD = splineFunctionDD(xG,x,M);
        if(~isa(k, 'function_handle'))
            % calcular os valores da 2� derivada da fun��o para os
            % pontos x do gr�fico
            yGfDD = funChoice(xG,k,3);
            % vetor do erro de cada ponto calculado para o gr�fico
            yGeDD = yGfDD-yGsDD; 
            E = [E max(abs(yGeDD))];
        end
    end
    
    
    % Gr�ficos das fun��es a ser estudadas
    if(PlotGraph)
        if(d(1) == 1)
            figure;     
            subplot(2,1,1);
            plot(xG,yGf);
            hold on;
            scatter(x,y);
            plot(xG,yGs);
            title('f(x)')
            legend({'f(x)','N�s','s(x)'})
            subplot(2,1,2);
            plot(xG,yGe);
            title('Erro')
            hold off;
            fprintf("Erro m�ximo absoluto para h = %f uniforme para f(x) � %f\n", h, E(1));
        end
        if(d(2) == 1)
            figure; 
            if(~isa(k, 'function_handle'))
                subplot(2,1,2);
                plot(xG,yGeD);
                title('Erro');
                subplot(2,1,1);
                plot(xG,yGfD);
                hold on;
                fprintf("Erro m�ximo absoluto para h = %f uniforme para f�(x) � %f\n", h,E(2));
                plot(xG,yGsD);
                title('f�(x)');
                legend({'f�(x)','s�(x)'})
            else
                plot(xG,yGsD);
                title('f�(x)');
            end
            
            hold off;
            
        end
        if(d(3) == 1)
            figure; 
            if(~isa(k, 'function_handle'))
                subplot(2,1,2);
                plot(xG,yGeDD);
                title('Erro');
                subplot(2,1,1);
                plot(xG,yGfDD);
                hold on;
                fprintf("Erro m�ximo absoluto para h = %f uniforme para f��(x) � %f\n", h, max(abs(yGe)));
                plot(xG,yGsDD);
                title('f��(x)');
                legend({'f��(x)','s��(x)'})
            else
                plot(xG,yGsDD);
                title('f��(x)');
                hold off;
            end  
        end
    end
    
    % Guardar, se pedido, o ficheiro com informa��o reltiva � fun��o
    % interpoladora
    if (isa(filenameS, 'string') || isa(filenameS, 'char')...
                                    && ~strcmp(filenameS,""))
        saveSpline(x,y,M,filenameS);
    end
   
end