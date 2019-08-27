from django.urls import path
from django.views.generic import TemplateView

app_name = 'portfolio'
urlpatterns = [
    path('', TemplateView.as_view(template_name="portfolio.html")),
]