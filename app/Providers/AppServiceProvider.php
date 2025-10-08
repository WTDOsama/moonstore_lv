<?php

namespace App\Providers;

use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Facades\View;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // 1️⃣  Force HTTPS in production
        if (App::environment('production')) {
            URL::forceScheme('https');
        }

        // 2️⃣  Cart composer for cms.parent view
        View::composer('cms.parent', function ($view) {
            $items     = collect();
            $cartCount = 0;
            $subTotal  = 0;

            if (Auth::guard('customer')->check()) {
                $items = \App\Models\Cart::with('product.image')
                         ->where('customer_id', Auth::guard('customer')->id())
                         ->get();
                $cartCount = $items->sum('qantity');
                $subTotal  = $items->sum(fn($r) => $r->price * $r->qantity);
            }

            $view->with(compact('items', 'cartCount', 'subTotal'));
        });

        // 3️⃣  Laravel defaults
        Schema::defaultStringLength(191);
        Paginator::useBootstrap();
    }
}
