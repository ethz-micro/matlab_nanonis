function applyMask(mask,Xrange,Yrange,color,alpha)

colorImage(1,1,:)=color(:);

colorImage = repmat(colorImage,size(mask));

hold on 
h = image(Xrange,Yrange,colorImage); 
hold off
alpha = mask*alpha;
set(h, 'AlphaData', alpha);

end
