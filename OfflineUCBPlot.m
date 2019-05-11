figure
sigma = 0.1;
filename = ['OfflineUCB_sigma=',num2str(sigma),'.mat'];
load(filename)
histogram(ratioHub)
size=20;
lg{1} = ['Success rate =',num2str(success/outloop*100),'%'];
l=legend(lg,'Location','NorthEast');
set(l,'FontSize',size-2)
xlabel('Poisoning effort ratio','FontSize',size)
ylabel('Number of trials','FontSize',size)
set(gca,'FontSize',size-4)