function errorAnalysis(s,k,a,b)
%% Descri��o
% A fun��o errorAnalysis tem como objetivo fazer o estudo do erro m�ximo
% cometido na interpola��o por um spline em fun��o do espa�amento entre 
% tro�os (uniforme)
% Recebe como argumentos:
%   - s: o tipo de spline interpolador
%       - s=0: spline natural
%       - s=1: spline completo
%       - s=2: spline not a knot
%   - k: a fun��o a usar na interpola��o
%   - a,b: os extremos do intervalo onde a fun��o fk(x) � interpolada

%% Constantes
    % limitamos o n�mero de tro�os por uma quest�o de mem�ria e tempo de
    % execu��o, ao inv�s de limitar h
    n0 = 3; % n�mero de tro�os inicial
    nMax = 1000; % n�mero aproximado de tro�os m�ximo

%% Calcular erro
% Sabemos que o erro m�ximo da interpola��o varia com uma pot�ncia do
% espa�amento entre n�s (cf. relat�rio). Assim, por forma a determinar essa 
% pot�ncia iremos tra�ar um gr�fico da depend�ncia de log(E) com log(h) 
% pelo que a pont�ncia de h ser� o declive desse gr�fico.
% Por forma a que os pontos que calculamos sucessivamente para o gr�fico de
% log(E) em fun��o log(h) tenham um espa�ameto uniforme a varia��o de n 
% (n�mero de tro�os) ser� exponencial com um fator de 2

    % Instanciar os vetores h e E respetivamente os valores do espa�amento
    % entre tro�os em cada itera��o
    h = zeros(ceil(log2(nMax/n0)),1);
    E = zeros(ceil(log2(nMax/n0)),3);
    
    % Calcular valores iniciais de h e E
    h(1) = (b-a)/n0;
    E(1,:) = splineUniform(s,k,a,b,n0,[1 1 1],0,0);
    
    % Varrer os valores de h e calcular o erro para cada um
    for i = 2:ceil(log2(nMax/n0))
        h(i) = 1/(n0*2^(i-1));
        E(i,:) = splineUniform(s,k,a,b,n0*2^(i-1),[1 1 1],0,0);
    end
   
%% Tra�ar gr�fico e estimar declive
    figure;
    loglog(h,E(:,1)); % tra�ar o gr�fico numa escala logar�tmica
    ylabel('log(|Erro_{max}|)  de f(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,1)),1); 
    fprintf("Declive de log(E) vs log(h) para f(x) � %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
    
    figure;
    loglog(h,E(:,2)); % tra�ar o gr�fico numa escala logar�tmica
    ylabel('log(|Erro_{max}|) de f�(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,2)),1); 
    fprintf("Declive de log(E) vs log(h) para f'(x) � %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
    
    figure;
    loglog(h,E(:,3)); % tra�ar o gr�fico numa escala logar�tmica
    ylabel('log(|Erro_{max}|)  de f��(x)');
    xlabel('log(h)');
    %detrminar o declive da reta
    slope = polyfit(log(h),log(E(:,3)),1); 
    fprintf("Declive de log(E) vs log(h) para f��(x) � %f com h a variar entre %f e %f\n", slope(1), (b-a)/3,  h(end));
end
