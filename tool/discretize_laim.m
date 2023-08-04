function data_dis = discretize_laim( data, answer )

%DIS_LAIM Label-Attribute Interdependence Maximization
% A Supervised Discretization Method for Multi-label Data.
% 
% [Writer]
%   Jaesung Lee (2016.10.11)
%
% [Reference]
%   Cano et al., "LAIM discretization for multi-label data",
%   Information Sciences 330(1):370-384, 2016
%
% [Input Variables]
%   data   (n by d matrix): n is the number of patterns
%                           d is the number of features
%   answer (n by q matrix): q is the number of labels
%
% [Usage]
%   data_dis = dis_laim( data, answer );

fcol = size( data, 2 );
lcol = size( answer, 2 );
data_dis = zeros( size( data ) );
nPos = sum(sum(answer));

for k=1:fcol
    vals = unique( data(:,k) );
    oB = (vals(1:end-1) + vals(2:end))/2;
    D = [-inf,inf];
    gM = 0;
    nIntervals = 1;
    
    while true
        B = setdiff( oB, D );
        if isempty( B ), break; end
        
        tM = zeros( length(B), 1 );
        for m=1:length(B)
            tD = sort( [D, B(m)] );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Calculate each LAIM value according to each tD
            % Prepare Quanta Matrix, qM
            qM = zeros( lcol, length(tD)-1 );
            for n=1:length(tD)-1
                qM(:,n) = sum( answer( and( data(:,k) >= tD(n), data(:,k) < tD(n+1) ), :) )';
            end
            
            tM(m) = sum((max(qM).^2)./sum(qM)) / (length(tD)*nPos);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        [btM,bidx] = nanmax( tM );
        if btM > gM
            D = sort( [D,B(bidx)] );
            gM = btM;
        else
            break;
        end
        nIntervals = nIntervals + 1;
    end
    
    % Now we get the interval D for the k-th feature
    for m=1:length(D)-1
        data_dis( and(data(:,k) >= D(m), data(:,k) < D(m+1)),k ) = m;
    end
end






















