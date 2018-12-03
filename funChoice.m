function y = funChoice(x,k,n)
% Descri��o
% A fun��o funChoice � a fun��o que � usada pelas fun��es: SplineNatural,
% SplineNotAKnot e SplineClamped para obter os valores da fun��o
% interpolada no n�s escolhidos e nos pontos selecionados para tra�ar
% o gr�fico. � tamb�m usada para obter o valor da primeira e segunda 
% derivadas  
% No caso do SplineClamped � tamb�m utilizada para fornecer o 
% valor das derivadas nos n�s 0 e n.
% A fun��o recebe como argumentos:
%   - x: um vetor de n�s para o quais v�o ser calculados o valor da 
% fun��o
%   - k: sele��o da fun��o a interpolar
%   - n: inteiro que seleciona a informa��o a fornecer acerca da
% fun��o
%       - n=0: retorna um vetor com valor da fun��o em cada ponto de x
%       - n=1: retorna um vetor (2x1) com o valor da 1� derivada nos
% n�s extremos
%       - n=2: retorna um vetor com valor de f'_k em cada ponto de x 
%       - n=3: retorna um vetor com valor de f''_k em cada ponto de x 
% � de notar que k pode ser um inteiro ou um 'function_handle' 
% consoante seja uma fun��o predefinida ou defina pelo utilizador,
% respetivamente.

% Fun��es Usadas e intervalos normalmente usados
% k -> fk(x)
% f1(x) = log(1+x)      em [0,1]
% f2(x) = 1/(1+25*x^2)  em [-1,1]
% f3(x) = sin(x^2)      em [0, 3*pi/2]
% f4(x) = tanh(x)       em [-20,20]

% C�lculo

if(~isa(k, 'function_handle')) %se a fun��o for predefinida
    if n == 0 % valores da fun��o em x
        switch k
            case 1
                y = log(1+x);
            case 2
                y = 1./(1+25*x.^2);
            case 3
                y = sin(x.^2);
            case 4
                y = tanh(x);
            case 5
                y = sin(pi*x);
            otherwise
                y = NaN(size(x));
        end
    elseif n == 1 % valores da derivada em x(0) e x(end)
        % instanciar o vetor da derivada da fun��o k nos n�s extremos
        y = zeros(2,1); 
        switch k
            case 1
                y(1) = 1/(1+x(1));
                y(2) = 1/(1+x(end));
            case 2
                y(1) = -50*x(1)/((1+25*x(1)^2)^2);
                y(2) = -50*x(end)/((1+25*x(end)^2)^2);
            case 3
                y(1) = 2*x(1)*cos(x(1)^2);
                y(2) = 2*x(end)*cos(x(end)^2);
            case 4
                y(1) = 1-tanh(x(1))^2;
                y(2) = 1-tanh(x(end))^2;
            case 5
                y(1) = pi*cos(pi*x(1));
                y(2) = pi*cos(pi*x(end));
            otherwise
                y = NaN(2,1);
        end
    elseif n == 2
        switch k
            case 1
                y = 1./(1 + x);
            case 2
                y = -((50*x)./(1 + 25*x.^2).^2);
            case 3
                y = 2*x.*cos(x.^2);
            case 4
                y = 2./(1+cosh(2*x));
            case 5
                y = pi*cos(pi*x);
            otherwise
                y = NaN(size(x));
        end
            
    elseif n ==3
        
        switch k
            case 1
                y = -1./((1 + x).^2);
            case 2
                y = (5000*x.^2)./(1 + 25*x.^2).^3 -...
                                          50./(1 + 25.*x.^2).^2;
            case 3
                y = 2*cos(x.^2)-4*x.^2.*sin(x.^2);
            case 4
                y = -((8*sinh(x))./(3*cosh(x)+cosh(3*x)));
            case 5
                y = -pi*pi*sin(pi*x);
            otherwise
                y = NaN(size(x));
        end
                
    else
        y = NaN;
    end
else % se a fun��o foi definida pelo utilizador
    if n == 0
        y = zeros(size(x));
        for i = 1:size(x,2)
           y(i) = k(x(i)); 
        end
    else
    % Se a fun��o n�o for nenhuma das predefinidadas teriamos de usar 
    % c�lculo simb�lico para determinar o valor da derivada no n�s
    % extremos. Assim, decidimos aproximar a derivada atrav�s de uma
    % diferen�a finita com h = 0.00001
        y = zeros(1,2);
        h = 0.00001;
        y(1) = (-3*k(x(1))+4*k(x(1)+h)-k(x(1)+2*h))/((2*h));
        y(2) = (3*k(x(end))-4*k(x(end)-h)+k(x(end)-2*h))/(2*h);
        
    end   
end
end
