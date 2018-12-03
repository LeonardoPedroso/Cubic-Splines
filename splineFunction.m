function yG = splineFunction(xG,x,y,M)
%% Descri��o
% A fun��o splineFunction � a que com base nos pares (x,y) e 
% nas segundas derivadas do spline interpolador anteriormente
% calculadas retorna o valor do spline em pontos entre os n�s.
% Recebe como argumentos:
%   - xG: os pontos x em que queremos determinar o valor que o 
% spline interpolador toma
%   - x: o vetor de n�s de interpola��o
%   - y: o vetor de valores da fun��o interpolada em cada um dos n�s
%   - M: o vetor dos valores da segunda derivada do spline 
% interpolador em cada um dos n�s
%   - a: o extremo inferior do intervalo onde estamos a interpolar a
%   a fun��o
%   - h: o espa�amento (uniforme) usado na interpola��o
% Retorna um vetor da mesma dimens�o de xG que corresponde ao valor 
% que spline interpolador toma para cada entrada de xG.   
%% Gerar pontos

    yG = zeros(size(xG)); % instanciar o vetor yG
    % varrer as entradas de xG e para cada valor calcular o valor 
    %que o spline interpolador toma

    for j = 1:size(xG,2) 
       % calcular o n�mero do tro�o a que a entrada atual de 
       % xG pertence.
       h = x(2)-x(1);
       i = ceil((xG(j)-x(1))/h); 
       % no caso particular de a entrada xG se tratar do extremo 
       % inferior temos de corrigir o valor calculado para o n�mero
       % do tro�o
       if(i == 0) 
           i = 1;
       end
       
       % Para valores muito reduzidos de h, os erros de 
       % arrendondamento fazem i ser ligeiramente superior ao 
       % valor inteiro correto, pelo que a fun��o ceil, retorne 
       % um valor errado
       if(i > size(x,2)-1)
           i = size(x,2)-1;
       end
       
       % Calcular o valor que o spline toma (cf. relat�rio)
       yG(j) = M(i)*((x(i+1)-xG(j))^3)/(6*h) ...
               +  M(i+1)*((xG(j)-x(i))^3)/(6*h)...
               + (y(i)-M(i)*((h^2)/6))*((x(i+1)-xG(j))/h)...
               + (y(i+1)-M(i+1)*((h^2)/6))*((xG(j)-x(i))/h);
    end
end