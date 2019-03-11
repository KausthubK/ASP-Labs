function plot2Classes(w1,w2, exp, name)
    
    fig = figure
    scatter(w1(:,1),w1(:,2), 'bo')
    hold on
    scatter(w2(:,1),w2(:,2), 'rx')
    legend(sprintf('Class 1 ' + name + length(w1)), sprintf('Class 2 '+ name + length(w2)))
    saveas(fig,sprintf("./Exp%i-results/",exp) + name + length(w1) +'.png')
end

