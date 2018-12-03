function saveSpline(x,y,M, sfilename)
%% Descri��o
% A fun��o saveSpline serve para guardar os dados, se o utilizador 
% assim o pretender
% A fun��o recebe como input:
%   -x: vetor de n�s de interpola��o
%   -y: vetor do valor da fun��o em cada um dos n�s
%   -M: o vetor dos valores da segunda derivada do spline interpolador
% em cada um dos n�s
%   -sfilename: o nome do ficheiro onde se ir�o guardar os valores
% � de notar que o spline fica apenas completamente definido sabendo 
% estes 3 vetores (x,y,M)

%% Guardar
fid = fopen(sfilename, 'wt'); %abrir o ficheiro
for i = 1:size(x,2) 
 % preencher duas colunas do ficheiro txt com os valores de x e de M
    if(i~=1)
       fprintf(fid, '\n');
    end
    % escrever no ficheiro os vetores em coluna
    fprintf(fid, '%f %f %f' ,x(i),y(i),M(i)); 
end
fclose(fid); % fechar o ficheiro

end
