function [nRow,nCol] = fitFig2Screen(nFig,pFig)
% screenSize = get(0,'screensize');
% nFig = 10; % figure number
pause(0.05)
width = pFig.Position(3);
height = pFig.Position(4);
aRatio = width/height;

nCol = 1;  % column number
nRow = 1;
if nFig > 1
    done = false;
    while ~done
        if aRatio > 1
            dx = width/nCol;
            nRow = floor(height/dx);
            if nRow*nCol < nFig
                nCol = nCol+1;
            else
                done = true;
            end
        else
            dy = height/nRow;
            nCol = floor(width/dy);
            if nRow*nCol < nFig
                nRow = nRow+1;
            else
                done = true;
            end
        end
    end
end
