import { Injectable } from '@angular/core';
import { HttpInterceptor } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';
@Injectable()
export class AuthenticationInterceptor implements HttpInterceptor {

    intercept(request, next) {
/*
        if (request.method.toLowerCase() === 'post')
        {
            if(request.body instanceof FormData)
            {
                console.log('Has body');
                request = request.clone.append('session',)
            }
        }

        if (req.method.toLowerCase() === 'post') {
            if (req.body instanceof FormData) {
              req =  req.clone({
                body: req.body.append(tokenName, tokenToAdd)
              })
            } else {
              const foo = {}; foo[tokenName] = tokenToAdd;
              req =  req.clone({
                body: {...req.body, ...foo}
              })
            }           
          } 
          if (req.method.toLowerCase() === 'get') {
            req = req.clone({
              params: req.params.set(tokenName, tokenName)
            });
          } 
          return req;    
*/
        //const newRequest = request.clone({withCredentials: true});
        const token = localStorage.getItem('token');
        if (!token)
        {
            return next.handle(request);
        }else
        {
            //const headers = new HttpHeaders({'session': token});

            const newRequest = request.clone({url: request.url + '&session=' + token});
            return next.handle(request);
        }
    }

}