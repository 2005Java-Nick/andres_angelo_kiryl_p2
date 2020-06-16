import { Injectable } from '@angular/core';
import { HttpInterceptor } from '@angular/common/http';
@Injectable()
export class AuthenticationInterceptor implements HttpInterceptor {

    intercept(request, next) {
        const token = localStorage.getItem('token');
        if (!token)
        {
            console.log(request.body);
            return next.handle(request);
        }else
        {
            const newRequest = request.clone({body: request.body + '&session=' + token});
            console.log(newRequest.body);
            return next.handle(newRequest);
        }
    }
}
