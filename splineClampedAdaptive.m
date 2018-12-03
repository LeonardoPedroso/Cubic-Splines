function M = splineClampedAdaptive(x,y,D)
%% Descri��o
% A fun��o splineClamped resolve o sistema de eqau��es lineares 
% necess�rio para determinar o valor da sengunda derivada de cada 
% um dos n�s do spline completo interpolador, com espa�amento 
% n�o uniforme 
% A fun��o recebe como input:
%   -x: o vetor de n�s a usar na interpola��o
%   -D: vetor (2x1) que corresponde �s derivadas da fun��o 
% interpolada nos n�s extremos 
%   -y: o vetor dos valores da fun��o interpolada em cada n�
% Retorna o vetor M das segundas derivadas em cada um dos n�s
    
%% Criar matriz spline completo
% Podemos reduzir o problema do spline completo � resolu��o de 
% um sistema de equa��es lineares representado por uma matriz 
% tridiagonal de dimens�es n+1 x n+1 (cf. relat�rio)
    
    n = size(x,2);
    A = zeros(n);
    
     %Matriz A - n�o � necess�ria (boa indica��o para a 
     % cria��o das diagonais)
     %A(1,1:2) = [2 1]; %condi��es de fecho
     %A(n,n-1:n) = [1 2];
     %for i = 2:n-1
        %A(i,i-1:i+1) = [x(i)-x(i-1) 2*(x(i+1)-x(i-1)) x(i+1)-x(i)];
        
    %end
   
    B = zeros(n,1);
    %condi��es de fecho
    B(1) = (6/(x(2)-x(1)))*((y(2)-y(1))/(x(2)-x(1))-D(1));
    B(n) = (6/(x(n)-x(n-1)))*(D(2)-(y(n)-y(n-1))/(x(n)-x(n-1)));
    
    for i = 2:n-1
        B(i) = 6*((y(i+1)-y(i))/(x(i+1)-x(i))-...
                                (y(i)-y(i-1))/(x(i)-x(i-1)));
    end
    
    % vetrores representativos das diagonais inferior, superior e
    % principal, respetivamente
    a = zeros(n,1);
    c = zeros(n,1);
    b = zeros(n,1);
    
    % Contruir diagonais (cf. relat�rio)
    for i = 2:n
       a(i) =  x(i)-x(i-1);
    end
    
    
    for i = 1:n-1
       c(i) =  x(i+1)-x(i);
    end
    
    for i = 2:n-1
        b(i) = 2*(x(i+1)-x(i-1));
    end
    
    % Condi��es fronteira
    c(1) = 1;
    a(n) = 1;
    b(1) = 2;
    b(n) = 2;

    % resolver o sistema de equa��es lineares
    %M = A\B;
    M = Thomas(a,b,c,B);
    

end