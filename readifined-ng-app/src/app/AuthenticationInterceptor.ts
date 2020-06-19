import { Injectable } from '@angular/core';
import { HttpInterceptor } from '@angular/common/http';
@Injectable()
export class AuthenticationInterceptor implements HttpInterceptor {

    intercept(request, next) {
        const token = localStorage.getItem('token');
        console.log(request);
        const newRequest = request.clone({withCredentials: false});
        console.log(newRequest);
        console.log(token);
        if (token === null || !token)
        {
            console.log(newRequest);
            return next.handle(newRequest);
        }else
        {
            console.log(newRequest.body);
            const newRequest1 = request.clone({body: newRequest.body + '&session=' + token});
            console.log(newRequest1.body);
            return next.handle(newRequest1);
        }
    }
}
