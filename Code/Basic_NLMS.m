clear all; close all;
u= [0.1 0.2 0.3 0.4 0.5 1:0.05:1.5]/1; %for different step sizes
%u= [0.01 0.05 0.1 0.2   ]/1; %for different step sizes
NorLMS_range =[      1 ];index =0;
NorLMS_Len_range = ceil([128  ]/1);Mean_Vol=1;
for j = 1:length(u)  
 for NorLMS_Len =NorLMS_Len_range      
for NorLMS =NorLMS_range      
rand('state',12345); randn('state',98765);     
    M=128;      %number of filter weights
    %generating a random signal for noise
    N=20000;     x=randn(N,1);    x=x/max(x); 
  %  Mean_Vol =sqrt(mean(abs(x).^2))
   uOG = u(j);  %selecting step size
    %defining a transfer function for the acoustic path taken by the noise
     P=0.5*[0:127]; 
   %  P=0.5*[0:20];
    d=conv(P,x); 
    %initializing adaptive filter wights, filter output and error
    W=zeros(M,1);      y=zeros(N,1);    e=zeros(N,1);
    x=x(:);    d=d(:);
    %lms algorithm for adaptive filter weights
    if NorLMS==0
     for n=M:N
        xvec=x(n:-1:n-M+1); 
        y(n)=W'*xvec;
        e(n)=d(n)-y(n); 
        W=W+uOG*xvec*e(n);
    end
    end
    if NorLMS==1
    for n=M:N
        xvec=x(n:-1:n-M+1); 
        u(n) = uOG*Mean_Vol; %1/sqrt(NorLMS_Len*xvec(end:-1:end-NorLMS_Len+1)'*xvec(end:-1:end-NorLMS_Len+1));
        y(n)=W'*xvec;
        e(n)=d(n)-y(n); 
        W=W+u(n)*xvec*(e(n));
    end
    end 
    index=index+1; 
   E_matrix(index,:) = e;
   E_matrixall (index,:) = mean(e);
end  
 end
end
E_matrix;
E_matrixall

    % figure;    subplot(3,1,1);    plot(e(M:N));    title('Error');    ylabel('Error');
    % xlabel('Cycles');   subplot(3,1,2);    plot(d(M:N));    xlabel('n');    ylabel('Signal');
    % title('d(n) vs y(n)');    hold on;    plot(y(M:N));    legend('d(n)','y(n)');    subplot(3,1,3)
    % plot(u(M:N));    xlabel('n');    ylabel('u');    title('Change in stepsize');



