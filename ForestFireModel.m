function Forest = ForestFireModel(T,p,f,N,th,BC,conn)
% This function simulate a neural network as forest fire
if nargin<7, conn = 2; end % connectivity (1nn 2nnn)
if nargin<6, BC = 'periodic';end % Boundary Cond ('free' or 'periodic')
if nargin<5, th = 0.1; end % threshold
if nargin<4, N = 64; end % lattice size
if nargin<3, f = 2e-4; end % prob of spontaneous ignition
if nargin<2, p = 0.1; end % growth rate
if nargin<1, T = 100; end % number of iteration (time)

mov = avifile('Forest.avi'); % initialise the movie file that will be created

% a: 1 < active state
% q: 0 < quiescent state
% r: 100 < refractory state

%% initial condition
F = 100*(rand(N)<0.4); % initialise forest with tree (q and r) here and there
                        % N*N matrix of 0's ans 100'ss randomly placed

%% connectivity array
switch conn
    %% nearest neighbour interactions
    case 1
        W = [0 1 0; 1 0 1; 0 1 0];
    %% next nearest neighbour interaction
    case 2
        W = [0 0 1 0 0; 0 sqrt(2) 2 sqrt(2) 0;...
            1 2 0 2 1; 0 sqrt(2) 2 sqrt(2) 0; 0 0 1 0 0];
        W = W/sum(sum(W)); % normalise for a net
end
%% end connectivity array

%% main loop
for ii = 1:T
    Ac = (F==1); % id's active fires in previous timestep
    Qu = (F ==0);% id's quiescent trees in previous timestep
    Rs = (F==100);% id's refractive trees in previous timestep
    if length(BC) == 4; % free
        CoA = conv2(double(Ac),W,'same'); %convolve fires 2/ connectivity array
    elseif length(BC) == 8 % periodic
        CoA = conv2_periodic(Ac,W);
    end
    
    Fr = (CoA>th).*Qu; % id's q trees whose input exceeded threshold
    Frn = (Fr ==0).*(rand(N)<f).*Qu;% with prob f selects trees from set q whose input does not exceeed threshold
    F = 100*Ac+100*(rand(N)>p).*Rs+Fr+Frn; % updates foerest by rules
    % first term: a- > r w/ prob1,
    % second term: r->q w prob p
    % third term: q->a if input exceed th or w/ prob f;
    
    Ac = (F==1); % redefine matrices of q, a & r tree locations
    Qu = (F==0);
    Rs = (F==100);
    
    figure(1)
    colormap(colorcube(12));
    im = image(Qu*7+Ac*5+Rs*10);
    axis square
    Frame = getframe(gca);
    mov = addframe(mov,Frame);
    Forest(:,:,ii) = F;
    
end % end the first loop
save Forest Forest
mov = close(mov)
    