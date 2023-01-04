"""Mixture model for matrix completion"""
from typing import Tuple
import numpy as np
from scipy.special import logsumexp
from common import *
import numpy as np
import pdb

def estep(X: np.ndarray, mixture: GaussianMixture) -> Tuple[np.ndarray, float]:
    """E-step: Softly assigns each datapoint to a gaussian component

    Args:
        X: (n, d) array holding the data, with incomplete entries (set to 0)
        mixture: the current gaussian mixture

    Returns:
        np.ndarray: (n, K) array holding the soft counts
            for all components for all examples
        float: log-likelihood of the assignment

    """
    n , K = X.shape[0] , mixture.var.shape[0]
    post = np.zeros((n,K))
    LL=0
    for i in range (n):
        # pdb.set_trace()
        mask = X[i] != 0 
                     
        mu , var , P = mixture.mu[:,mask] , np.expand_dims(mixture.var,1) , np.expand_dims(mixture.p,1) 
        d = mu.shape[1]
        
        XX = np.tile(X[i][mask], (K, 1))        
        c= (-d/2)*np.log(2*np.pi*var)
        E= -np.linalg.norm(XX-mu,axis=1,keepdims=2)**2/(2*var)
        # we have calculating the N pdf in the log domain - uncomment to get the previous working code
        # c= (2*np.pi*var)**(-d/2) 
        # E = np.exp(-np.linalg.norm(XX-mu,axis=1,keepdims=2)**2/(2*var))        
        cE = c+E
        F= np.log(P+1e-16) + cE
        # F= np.log(P+1e-16) + np.log(cE)
        LL += logsumexp(F)
        post[i,:]= np.exp((F - np.tile(logsumexp(F),(K,1))).T)
        

    return (post,LL)



def mstep(X: np.ndarray, post: np.ndarray, mixture: GaussianMixture,
          min_variance: float = .25) -> GaussianMixture:
    """M-step: Updates the gaussian mixture by maximizing the log-likelihood
    of the weighted dataset

    Args:
        X: (n, d) array holding the data, with incomplete entries (set to 0)
        post: (n, K) array holding the soft counts
            for all components for all examples
        mixture: the current gaussian mixture
        min_variance: the minimum variance for each gaussian

    Returns:
        GaussianMixture: the new gaussian mixture
    """
    n , K = X.shape[0] , post.shape[1]
    mu , var , P= mixture.mu , mixture.var , mixture.p
    N=post.sum(axis=0)
    P= N/n

    for j in range (K):
        d = X.shape[1]
        OI=np.nan_to_num(X/X)
        # MU =np.expand_dims(np.sum(post[:,[j]]*X,axis=0)/np.sum(OI*post[:,[j]],axis=0),1)
        MU =np.sum(post[:,[j]]*X,axis=0)/np.sum(OI*post[:,[j]],axis=0)
        mask = np.sum(post[:,[j]]*OI,axis=0)>=1
        MUJ = mu[j].copy()
        MUJ[mask] = MU[mask]
        mu[j] = MUJ
        # pdb.set_trace()
        # for l in range (d):
            
        #     if np.sum(OI*post[:,[j]],axis=0)[l] >= 1:
        #         mu[j,l] =  MU[l]
        

        
        D = np.sum(OI, axis=1,keepdims=1)
        denom = np.sum(D*post[:,[j]])
        mutile=np.tile(mu[j],(n,1))*OI
        
        var[j] = (post[:,[j]]*np.linalg.norm(X-mutile,axis=1,keepdims=1)**2).sum(axis=0)/denom
    var [ var < min_variance ] = min_variance
    # print('lpm')
    return (GaussianMixture(mu, var, P))


def run(X: np.ndarray, mixture: GaussianMixture,
            post: np.ndarray) -> Tuple[GaussianMixture, np.ndarray, float]:
        """Runs the mixture model
    
        Args:
            X: (n, d) array holding the data
            post: (n, K) array holding the soft counts
                for all components for all examples
    
        Returns:
            GaussianMixture: the new gaussian mixture
            np.ndarray: (n, K) array holding the soft counts
                for all components for all examples
            float: log-likelihood of the current assignment
        """
        old = None
        new = None
        while old is None or new - old > abs(new)*1e-6:
            
            old=new
            # import pdb ; pdb.set_trace()
            post , new = estep(X,mixture)
            mixture = mstep(X,post,mixture)
            
            

        return (mixture, post, new)


def fill_matrix(X: np.ndarray, mixture: GaussianMixture) -> np.ndarray:
    """Fills an incomplete matrix according to a mixture model

    Args:
        X: (n, d) array of incomplete data (incomplete entries =0)
        mixture: a mixture of gaussians

    Returns
        np.ndarray: a (n, d) array with completed data
    """
    def estep(X: np.ndarray, mixture: GaussianMixture) -> Tuple[np.ndarray, float]:
        n , K = X.shape[0] , mixture.var.shape[0]
        post = np.zeros((n,K))
        LL=0
        for i in range (n):
    
            mask = X[i] != 0 
                         
            mu , var , P = mixture.mu[:,mask] , np.expand_dims(mixture.var,1) , np.expand_dims(mixture.p,1) 
            d = mu.shape[1]
            
            XX = np.tile(X[i][mask], (K, 1))        
            c= (-d/2)*np.log(2*np.pi*var)
            E= -np.linalg.norm(XX-mu,axis=1,keepdims=2)**2/(2*var)
            cE = c+E
            F= np.log(P+1e-16) + cE
            LL += logsumexp(F)
            post[i,:]= np.exp((F - np.tile(logsumexp(F),(K,1))).T)
            
    
        return (post,LL)
    XX = X.copy()    
    post = estep(X,mixture)[0]
    mask = X == 0
    
    ematrix = post @ mixture.mu
    XX[mask] = ematrix[mask]
    return XX


def RUN(k,Seed, Fixed=False):
    
    LL = np.zeros((k,Seed))
    if Fixed is False:
        for K in range (1,k+1):
            for seed in range (Seed):
                X = np.loadtxt('test_incomplete.txt')
                Xd = init(X,K,seed)
                
            
                LL[K-1][seed]=run(X,Xd[0],Xd[1])[2]
                print('LL for K = ',K,'and seed =',seed,'\n', run(X,Xd[0],Xd[1])[2])
    else:
        LL = np.zeros((Seed,Seed))
        for seed in range (Seed):
            X = np.loadtxt('netflix_incomplete.txt')
            Xd = init(X,k,seed)
            
        
            LL[seed]=run(X,Xd[0],Xd[1])[2]
            print('LL for K = ',k,'and seed =',seed,'\n', run(X,Xd[0],Xd[1])[2])
    return np.max(LL)