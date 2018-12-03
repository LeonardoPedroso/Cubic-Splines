function plotSplineFromTxt(filename)
%% Descri��o
% A fun��o saveSpline serve para importar e desenhar um spline 
% que foi guardado num ficheiro de texto atrav�s da fun��o saveSpline.
% A fun��o recebe como input:
%   -sfilename: o nome do ficheiro onde est�o guardados os dados

%% Importar pontos
    fid = fopen(filename,'rt'); % abrir o fichero de texto dos dados
    if(fid<=3) % falha na abertura do ficheiro
        fprintf("Erro na abertura do ficheiro %s\n", filename);
    end
    % importar os valores e organiza-los numa matriz
    D = cell2mat(textscan(fid, '%f%f%f', 'MultipleDelimsAsOne',true ...
        ,'Delimiter',' ', 'HeaderLines',0));
    fclose(fid); % fechar o ficheiro
        
    if(max(size(D))==0) % Se n�o for poss�vel extrair valores
        fprintf("Erro na abertura do ficheiro %s\n", filename);
    end
    
    nG = 1000;  
%% Criar gr�fico
    
    % instanciar o vetor com os x dos pontos do gr�fico
    xG = [D(1,1):(D(end,1)-D(1,1))/nG:D(end,1)]; 
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos tra�ar o gr�fico a partir da fun��o
    % splineFunctionAdaptive uma vez que o espa�amento pode ser 
    % vari�vel
    yGs = splineFunctionAdaptive(xG,D(:,1)',D(:,2)',D(:,3)');
    % calcular os valores da fun��o interpolada para os pontos x 
    % do gr�fico

    figure;
    plot(xG,yGs); % plot do spline interpolador 
    t = xlabel('x');
    t.Color = 'blue';
end

