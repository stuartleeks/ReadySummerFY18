#!/bin/bash

kubectl set image deployments rolling rolling=stuartleeks/htmlrefresh:blue
