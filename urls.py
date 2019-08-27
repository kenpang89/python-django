from django.contrib import admin
from django.urls import path
from django.conf.urls import include

urlpatterns = [
    # path('', HomeView.as_view(), name='home'),
    path('admin/', admin.site.urls),
    path('', include('portfolio.urls', namespace='portfolio'))
]
