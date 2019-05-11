figure
sigma = 0.1;
DeltaList = [1,0.5,0.2];
colors1 = {'-r','-b','-k'};
colors2 = {'--r','--b','--k'};
cur = 1;
lg = {};
run = 1;
for Delta = DeltaList
    filename = ['OnlineGreedyACA_sigma=',num2str(sigma),'_Delta=',num2str(Delta),'.mat'];
    load(filename)
    cumCost = zeros(T,1);
    cumCost(1) = Cost(1)/outloop;
    for t = 2:T
        cumCost(t) = cumCost(t-1) + Cost(t)/outloop;
    end
    semilogx(1:T,cumCost,colors1{cur},'LineWidth',2,'MarkerSize',10)
    hold on
    lg{run} = ['ACE,\Delta=',num2str(Delta)];
    run = run + 1;
    
    filename = ['OnlineGreedyNIPS_sigma=',num2str(sigma),'_Delta=',num2str(Delta),'.mat'];
    load(filename)
    cumCost = zeros(T,1);
    cumCost(1) = Cost(1)/outloop;
    for t = 2:T
        cumCost(t) = cumCost(t-1) + Cost(t)/outloop;
    end
    semilogx(1:T,cumCost,colors2{cur},'LineWidth',2,'MarkerSize',10)
    hold on
    lg{run} = ['Jun,\Delta=',num2str(Delta)];
    run = run + 1;
    cur = cur + 1;
end
size=20;
l=legend(lg,'Location','NorthWest');
set(l,'FontSize',size-2)
xlabel('Time','FontSize',size)
ylabel('Cost','FontSize',size)
set(gca,'FontSize',size-4)


% figure
% sigma = 0.1;
% DeltaList = [0.2,0.5,1];
% for Delta = DeltaList
%     filename = ['OnlineGreedyNIPS_sigma=',num2str(sigma),'_Delta=',num2str(Delta),'.mat'];
%     load(filename)
%     cumCost = zeros(T,1);
%     cumCost(1) = Cost(1)/outloop;
%     for t = 2:T
%         cumCost(t) = cumCost(t-1) + Cost(t)/outloop;
%     end
%     semilogx(1:T,cumCost,'LineWidth',2,'MarkerSize',10)
%     hold on
% end

figure
sigma = 0.1;
Delta = 1;
filename = ['OnlineGreedyACA_sigma=',num2str(sigma),'_Delta=',num2str(Delta),'.mat'];
load(filename)
cumPlay = zeros(T,1);
cumPlay(1) = Target(1)/outloop;
for t = 2:T
    cumPlay(t) = cumPlay(t-1) + Target(t)/outloop;
end
plot(1:T,cumPlay,'-r','LineWidth',2,'MarkerSize',10)
hold on

filename = ['OnlineGreedyWithout_sigma=',num2str(sigma),'_Delta=',num2str(Delta),'.mat'];
load(filename)
cumPlay = zeros(T,1);
cumPlay(1) = Target(1)/outloop;
for t = 2:T
    cumPlay(t) = cumPlay(t-1) + Target(t)/outloop;
end
plot(1:T,cumPlay,'--b','LineWidth',2,'MarkerSize',10)
hold on

lg = {'Attacked','Without attack'}
size=20;
l=legend(lg,'Location','NorthWest');
set(l,'FontSize',size-2)
xlabel('Time','FontSize',size)
ylabel('Target arm pulls','FontSize',size)
set(gca,'FontSize',size-4)