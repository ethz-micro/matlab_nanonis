function data=blurData(data,npix)
    N=2*npix+1;
    %create 2n+1 X 2n+1 matrices by adding 0:2n row to the extrimities
    matrices = zeros(size(data,1)+N-1,size(data,2)+N-1,N^2);
    idx=1;
    for i=1:N
        for j=1:N
            matrices(i:end-N+i,j:end-N+j,idx)=data;
            idx=idx+1;
        end
    end
    result=squeeze(nanmean(matrices,3));
    data=result(1+npix:end-npix,1+npix:end-npix);
    
end