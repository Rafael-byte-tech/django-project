from django.shortcuts import render

# Create your views here.
def home (request):
    return render(request, "home.html", { "message": "Welcome to your Django App!" })