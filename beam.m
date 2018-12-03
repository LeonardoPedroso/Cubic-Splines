function beam(filename,filenameSave)
%% Descri��o
% A fun��o beamUniform interpola um conjunto de pontos (x,y) obtidos
% experimentalmente de um modo de vibra��o viga encastrada em ambas as
% extremidades, em que os pontos t�m um espa�amento uniforme. 
% Para a resolu��o deste problema usaremos um spline completo (cf.
% relat�rio) com derivadas nulas nas extremidades.
% A fun��o recebe como input o nome do ficheiro no qual est�o gurdados
% os valores de (x,y) da viga organizados em duas colunas e o nome do 
% ficheiro em que pode ser guardado o spline. Se este nome for 
% inv�lido n�o � guardado

%% Constantes
    nG = 500; % n�mero de pontos usados para o tra�ar o gr�fico da viga

%% Importar pontos
    fid = fopen(filename,'rt'); % abrir o fichero de texto dos dados
    % importar os valores e organiza-los numa matriz
    V = cell2mat(textscan(fid, '%f%f', 'MultipleDelimsAsOne',true ...
        ,'Delimiter',' ', 'HeaderLines',0));
    fclose(fid); % fechar o ficheiro

%% Obter o vetor M
    % Sabemos que a derivada nos n�s extremo de uma viga encastrada em
    % ambas as extremidades � nula nesses pontos pelo que D � nulo
    D = [0;0];
    % Calcular o vetor das segundas derivadas do spline interpolador em
    % cada um dos n�s
    % Usando a fun��o splineClampedAdaptive � poss�vel interpolar 
    % corretamente o modo de vibra��o da viga para n�s com espa�amento n�o
    % uniforme
    M = splineClampedAdaptive(V(:,1)',V(:,2)',D);
    
    
%% Criar gr�fico
    xG = [0:1/nG:1]; % instanciar o vetor com os x dos pontos do gr�fico
    % calcular os valores do spline interpolador nos pontos x onde
    % pretendemos tra�ar o gr�fico a partir da fun��o splineFunction
    yG = splineFunctionAdaptive(xG,V(:,1)',V(:,2)',M);
    figure;
    plot(xG,yG); % plot do spline interpolador
    hold on;
    scatter(V(:,1),V(:,2)); % plot dos valores experimentais
    title('Deslocamento vertical da viga')
    xlabel('x [m]');
    ylabel('w(x)');
    hold off;

% Criar gr�fico da primeira derivada
    DyG = splineFunctionD(xG,V(:,1)',V(:,2)',M);
    figure;
    plot(xG,DyG); % plot do spline interpolador
    hold on;
    title('Rota��o da viga')
    xlabel('x [m]');
    hold off;
    
% Criar gr�fico da segunda derivada
    DDyG = splineFunctionDD(xG,V(:,1)',M');
    figure;
    plot(xG,DDyG); % plot do spline interpolador
    hold on;
    title('Curvatura da viga');
    xlabel('x [m]');
    hold off;

%% Guardar
    %S� guarda o spline num ficheiro se o nome for v�lido 
    if (isa(filenameSave, 'string') || isa(filenameSave, 'char') ...
                                          && ~strcmp(filenameSave,""))
        saveSpline(V(:,1)',V(:,2)',M,filenameSave);
    end
end