---
layout: page
title: Social Media Sentiment Analysis Research
description:
img: assets/img/projects/iphone_twitter.jpg
importance: 1
category: Research
toc:
  sidebar: left
sitemap: false
---

<hr style="margin-top: 3rem"/>

### Introduction

The general purpose of this project was to analyze the sentiment for iPhone 8, iPhone X, and iPhone 11 releases using various media outlets such as news, press, and tech articles as well as general consumer responses via Twitter and seeing if or how that sentiment relates to or is reflected in Apple’s stock price. The iPhone 8 was released on September 22, 2017; the iPhone X was released on November 3, 2017; and the iPhone 11 was released on September 20, 2019.

I wanted to see how people were talking about iPhone products on Twitter, what major news sources reported about new iPhone releases, and how the stock performed before and after each release. I ran a regression analysis with the data I collected to identify factors that affected AAPL stock performance. With the model I created, people will be able to predict AAPL stock returns based on consumer sentiment. Apple can increase its stock returns by being more engaged with general consumers on social media platforms before and after each new iPhone release.

### Data

<p style="margin-bottom: 0.5rem;">There were four major sources of data:</p>
<ul>
<li>Google Trends:
<p style="margin-top: 0.5rem;">I wanted to see how the popularity of iPhone changed through out the year and how it correlated with each new phone release. I was able to manually download the data from Google.</p>
</li>
<li>
Social Media – Twitter:
<p style="margin-top: 0.5rem;">I created 3 Twitter API accounts with Sandbox Subscription to pull 500 tweets per day, three days before the release (which was counted as the “before” group) and the release date plus two days after each release (which counted as the “after” group), for a total of 6 days’ worth of Twitter data for each iPhone release. 500 * 6 * 3 = 9000 tweets in total.</p>

{% highlight py %}

from searchtweets import load_credentials, gen_rule_payload, collect_results

search_args = load_credentials(filename='./twitter_keys.yaml', yaml_key='search_tweets_api', env_overwrite=False)

rule = gen_rule_payload('iphone 11 lang:en', results_per_call=100, from_date='201909220800', to_date='201909222200')

tweets = collect_results(rule, max_results=500, result_stream_args=search_args)

[print(tweet.all_text, end='\n\n') for tweet in tweets[:]]

{% endhighlight %}

<div class="caption">
    Search Tweets Code Snippet
</div>

</li>
<li>Stock Information:
<p style="margin-top: 0.5rem;">The stock information for iPhone 8 and iPhone X that was released in 2017 came from WRDS. As 2019 stock information was not yet available via WRDS, for the iPhone 11, the data was collected from Yahoo Finance. I used (AAPL Return – SP500 Market Index Return) to calculate Adjusted Returns for AAPL. Date_idx shows the index of the dates with 0 being the release date.</p>

<div class="table-responsive">
<table class="table table-sm">
  <thead>
    <tr>
      <th style="text-align: left">Phone</th>
      <th style="text-align: right">Date_idx</th>
      <th style="text-align: right">AAPL</th>
      <th style="text-align: right">SP500</th>
      <th style="text-align: right">Adj_Return</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">-3</td>
      <td style="text-align: right">0.000378</td>
      <td style="text-align: right">0.00111</td>
      <td style="text-align: right">-0.000732</td>
    </tr>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">-2</td>
      <td style="text-align: right">-0.01676</td>
      <td style="text-align: right">0.000634</td>
      <td style="text-align: right">-0.017392</td>
    </tr>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">-1</td>
      <td style="text-align: right">-0.01717</td>
      <td style="text-align: right">-0.00305</td>
      <td style="text-align: right">-0.014126</td>
    </tr>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">-0.00978</td>
      <td style="text-align: right">0.000648</td>
      <td style="text-align: right">-0.010427</td>
    </tr>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">-0.00882</td>
      <td style="text-align: right">-0.00222</td>
      <td style="text-align: right">-0.0066</td>
    </tr>
    <tr>
      <td style="text-align: left">iPhone8</td>
      <td style="text-align: right">2</td>
      <td style="text-align: right">0.017204</td>
      <td style="text-align: right">0.000072</td>
      <td style="text-align: right">0.017132</td>
    </tr>
  </tbody>
</table>
</div>

<div class="caption">
    Stock Information
</div>
</li>
<li>
News Articles
<ul>
<li>Apple.com Newsroom: 7 articles</li>
<li>TechCrunch: 11 articles</li>
<li>Wall Street Journal: 31 articles</li>
</ul>
<p style="margin-top: 0.75rem;">I grouped the articles into three folders: Apple (Apple Newsroom), TC (TechCrunch), and WSJ (Wall Street Journal). I then looped through each txt file in each folder to read all articles as a large string to store in a DataFrame so I could calculate sentiment score for each news source.</p>
</li>
</ul>

### Analysis

Knowing that I was going to repeat some steps many times, I defined functions to simplify the analysis. 

I started by visually exploring the data and making plots.

Google trends data showed that the popularity of “iPhone” searches dramatically started to increase about 2 weeks prior to each release date. I used this data to narrow down the scope and set the timeframes for how far back I needed to go to find articles prior to each release date.

{% include figure.html path="assets/img/projects/google_trends.png" title="Google Trends" alt="Google Trends" class="img-fluid rounded z-depth-1" caption="Google Trends" zoomable=true %}

AAPL stock performance was quite different for each new phone release. In the graphs below, the axis goes up to 3 days prior to and 2 days subsequent to each release date (0). The line graph shows that AAPL stock experienced some increase after the releases of iPhone 8 and iPhone 11, while it dropped after the release of iPhone X.

{% include figure.html path="assets/img/projects/stock_performance.png" title="Stock Performance" alt="Stock Performance" class="img-fluid rounded z-depth-1" caption="Stock Performance" zoomable=true %}

A closer look at the average performance of AAPL stock returns told a different story. The blue bars represent the 3-day average adjusted stock returns for each iPhone before release, and orange bars represent the 3-day average adjusted stock returns for each iPhone after release. The stock return increased the most for iPhone 8, changing from negative to positive return, and it also performed well for iPhone X. However, the adjusted stock return dropped significantly after the release of iPhone 11. This graph made me think that iPhone 11 might not be a successful iPhone release.

{% include figure.html path="assets/img/projects/average_stock_performance.png" title="Average Stock Performance" alt="Average Stock Performance" class="img-fluid rounded z-depth-1" caption="Average Stock Performance" zoomable=true %}

I grouped the articles into three folders: Apple, TechCrunch, and WSJ. The articles tend to mention multiple iPhone products together, so it was difficult to attribute each article to only one phone. Also, due to my desire to evaluate the sentiment of the press and marketing leading up to each release date, in addition to the major decline in the publishing of Apple and iPhone related articles after each release, I decided not to split the articles into 6 separate groups as I did for tweets. I looped through each txt file in each folder to read all articles as a large string.

With the <b>Inquirer Dictionary</b>, I calculated sentiment score <b>net_pos_pct</b> for each news source. I did not use LM Financial Dictionary for WSJ articles because I wanted to compare sentiment scores for each news source, and I thought it would be better and more consistent to use the same dictionary to do so. The variable <b>net_pos_pct</b> is net positive percentage, which is calculated using <b>(Positive words – Negative words) / Total words</b>.

News reports generally relayed positive sentiment about iPhones, with Apple being the most positive about its own products. I defined a function to generate word clouds that allowed me to add weights to words based on the frequency of their appearances and show them in different sizes based on the weights to better visualize the content of the articles and tweets. By looking at the top words for each news source, it is clear that news sources emphasized different aspects of iPhones, reflecting each news source’s area of expertise. <b>Apple</b> mainly used words such as camera, photo, video (because new or updated camera was the key new feature) and store, customer, available, etc. <b>TechCrunch</b> frequently used tech words such as biometrics, screen, security, device, sensor, etc. <b>WSJ</b> liked to use words such as revenue, sales, share, and investor.

Sentiment score for each Apple Newsroom, TechCrunch, and WSJ:

{% include figure.html path="assets/img/projects/sentiment_score.png" title="Sentiment Score" alt="Sentiment Score" class="img-fluid rounded z-depth-1" caption="Sentiment Score" zoomable=true %}

Top words - Apple Newsroom

<div style="margin-left: auto; margin-right: auto; width: 65%;">
{% include figure.html path="assets/img/projects/apple_newsroom_top_words.png" title="Apple Newsroom Top Words" alt="Apple Newsroom Top Words" class="img-fluid rounded z-depth-1" caption="Apple Newsroom Top Words" zoomable=true %}
</div>

Top words - TechCrunch

<div style="margin-left: auto; margin-right: auto; width: 65%;">
{% include figure.html path="assets/img/projects/techcrunch_top_words.png" title="TechCrunch Top Words" alt="TechCrunch Top Words" class="img-fluid rounded z-depth-1" caption="TechCrunch Top Words" zoomable=true %}
</div>

Top words - Wall Street Journal

<div style="margin-left: auto; margin-right: auto; width: 65%;">
{% include figure.html path="assets/img/projects/wsj_top_words.png" title="Wall Street Journal Top Words" alt="Wall Street Journal Top Words" class="img-fluid rounded z-depth-1" caption="Wall Street Journal Top Words" zoomable=true %}
</div>

I set the tweets into 6 groups: iPhone 8 pre, iPhone 8 post, iPhone x pre, iPhone x post, iPhone 11 pre, iPhone 11 post, and then applied <b>groupby(Phone).mean()</b> to get the mean <b>net  positive percentage</b> for each group. I then mapped <b>net positive percentage</b> values to the stock performance file.

<div class="table-responsive">
<table class="table table-sm">
  <thead>
    <tr>
      <th style="text-align: left"></th>
      <th style="text-align: right">Phone</th>
      <th style="text-align: right">pre_post</th>
      <th style="text-align: right">Adj_Return</th>
      <th style="text-align: right">net_pos_pct</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">0</td>
      <td style="text-align: right">iPhone11</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0.00082184</td>
      <td style="text-align: right">3.82E-06</td>
    </tr>
    <tr>
      <td style="text-align: left">1</td>
      <td style="text-align: right">iPhone11</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">-0.006033761</td>
      <td style="text-align: right">4.39E-06</td>
    </tr>
    <tr>
      <td style="text-align: left">2</td>
      <td style="text-align: right">iPhone8</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">-0.01075</td>
      <td style="text-align: right">1.08E-06</td>
    </tr>
    <tr>
      <td style="text-align: left">3</td>
      <td style="text-align: right">iPhone8</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">3.50E-05</td>
      <td style="text-align: right">2.05E-06</td>
    </tr>
    <tr>
      <td style="text-align: left">4</td>
      <td style="text-align: right">iPhoneX</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0.001926667</td>
      <td style="text-align: right">1.82E-06</td>
    </tr>
    <tr>
      <td style="text-align: left">5</td>
      <td style="text-align: right">iPhoneX</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0.011764667</td>
      <td style="text-align: right">4.08E-06</td>
    </tr>
  </tbody>
</table>
</div>

<div class="caption">
    Stock Performance & iPhone Pre-Post Release Net Positive Percentage
</div>

Consumers in general became more positive after a new phone was released than they were before the release, but that jump was much smaller for iPhone 11 than for the iPhone 8 or iPhone X models.

{% include figure.html path="assets/img/projects/iphone_pre_post_npp.png" title="iPhone Pre-Post Release Net Positive Percentage" alt="iPhone Pre-Post Release Net Positive Percentage" class="img-fluid rounded z-depth-1" caption="iPhone Pre-Post Release Net Positive Percentage" zoomable=true %}

Top words that people used in their tweets, filtering out stop words.

<div style="margin-left: auto; margin-right: auto; width: 65%;">
{% include figure.html path="assets/img/projects/twitter_top_words.png" title="Twitter Top Words" alt="Twitter Top Words" class="img-fluid rounded z-depth-1" caption="Twitter Top Words" zoomable=true %}
</div>

I used <b>get_dummies</b> to create three dummies, iPhone 8, iPhone x, and iPhone 11, dropping iPhone 11 which would be used as the “baseline” because only N-1 dummy variables were needed.

<div class="table-responsive">
<table class="table table-sm">
  <thead>
    <tr>
      <th style="text-align: left"></th>
      <th style="text-align: right">Phone</th>
      <th style="text-align: right">pre_post</th>
      <th style="text-align: right">Adj_Return</th>
      <th style="text-align: right">net_pos_pct</th>
      <th style="text-align: right">iPhone11</th>
      <th style="text-align: right">iPhone8</th>
      <th style="text-align: right">iPhoneX</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: left">0</td>
      <td style="text-align: right">iPhone11</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0.00082184</td>
      <td style="text-align: right">3.82E-06</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0</td>
    </tr>
    <tr>
      <td style="text-align: left">1</td>
      <td style="text-align: right">iPhone11</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">-0.006033761</td>
      <td style="text-align: right">4.39E-06</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0</td>
    </tr>
    <tr>
      <td style="text-align: left">2</td>
      <td style="text-align: right">iPhone8</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">-0.01075</td>
      <td style="text-align: right">1.08E-06</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0</td>
    </tr>
    <tr>
      <td style="text-align: left">3</td>
      <td style="text-align: right">iPhone8</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">3.50E-05</td>
      <td style="text-align: right">2.05E-06</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0</td>
    </tr>
    <tr>
      <td style="text-align: left">4</td>
      <td style="text-align: right">iPhoneX</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0.001926667</td>
      <td style="text-align: right">1.82E-06</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">1</td>
    </tr>
    <tr>
      <td style="text-align: left">5</td>
      <td style="text-align: right">iPhoneX</td>
      <td style="text-align: right">1</td>
      <td style="text-align: right">0.011764667</td>
      <td style="text-align: right">4.08E-06</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">0</td>
      <td style="text-align: right">1</td>
    </tr>
  </tbody>
</table>
</div>

<div class="caption">
    Stock Performance & iPhone Pre-Post Release Net Positive Percentage Dummy
</div>

I ran a regression analysis using this DataFrame. The p-values for the independent variables are all significant, except that for <b>pre_post</b>. The negative coefficient of <b>pre_post</b> shows that AAPL stock generally does worse after new phone releases than before the release (but it’s not significant). <b>pre_post</b> has a larger p-value and is not a good indicator. This is likely due to different stock performance before and after release for each iPhone and limited data (only 6 observations). The variable <b>net_pos_pct</b> is a very small number and that is why it has a large coefficient. Since iPhone 11 was dropped and used as the baseline, the coefficients for iPhone 8 and iPhone X signify that, compared to <b>iPhone 11</b>, <b>iPhone 8</b> and <b>iPhone X</b> had a more positive affect on AAPL stock returns. I may conclude that iPhone 8 and iPhone X were more successful iPhone models than the iPhone 11 was, partly due to a successful marketing strategy that helped to produce more positive sentiment.

{% include figure.html path="assets/img/projects/regression_analysis.png" title="Regression Analysis" alt="Regression Analysis" class="img-fluid rounded z-depth-1" caption="Regression Analysis" zoomable=true %}

{% highlight py %}

import re, os, pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from wordcloud import WordCloud
import matplotlib.pyplot as plt
from linearmodels import OLS
import seaborn as sns
from sklearn.feature_extraction import text

# define constant variables
iphone8_tweets_pre_release_folder = 'iphone8_tweets_pre_release'
iphone8_tweets_post_release_folder = 'iphone8_tweets_post_release'
iphonex_tweets_pre_release_folder = 'iphonex_tweets_pre_release'
iphonex_tweets_post_release_folder = 'iphonex_tweets_post_release'
iphone11_tweets_pre_release_folder = 'iphone11_tweets_pre_release'
iphone11_tweets_post_release_folder = 'iphone11_tweets_post_release'
iphone_tweets_pre_release_folder = 'iphone_tweets_pre_release'
iphone_tweets_post_release_folder = 'iphone_tweets_post_release'
apple_articles = 'apple_articles'
tc_articles = 'tc_articles'
wsj_articles = 'wsj_articles'

# define global variables
inqdict = None
inqpos = None
inqneg = None
dtmd = None
voc = None


# initialize global variables inqdic, inqpos, and inqneg
def initialize():
    global inqdict
    inqdict = pd.read_excel('inquirerbasic.xls')
    global inqpos
    inqpos = set(re.sub(r'#\d+', '', w.lower()) for w in inqdict.loc[inqdict['Positiv'].notnull(), 'Entry'])
    global inqneg
    inqneg = set(re.sub(r'#\d+', '', str(w).lower()) for w in inqdict.loc[inqdict['Negativ'].notnull(), 'Entry'])


# read all files in one folder as a str
def read_files(folder):
    content = ''
    for f in os.listdir(folder):
        with open(folder + '/' + f, 'r', encoding='utf-8') as t:
            content += t.read() + '\n'
    return content


# create document term matrix
def document_term_matrix(content):
    vec = CountVectorizer(max_features=1500, stop_words='english', ngram_range=(1, 1))

    global dtmd
    dtmd = pd.DataFrame(vec.fit_transform([content]).todense())

    global voc
    voc = {v: k for k, v in vec.vocabulary_.items()}


# find top words
def top_words(name):
    word_counts = dtmd.sum(axis=0)
    word_counts.index = word_counts.index.map(voc)
    word_counts.sort_values(ascending=False, inplace=True)
    top = word_counts.nlargest(25)
    top.to_csv(name)


# generate word cloud for most frequently appeared words
def word_cloud_show(content, stop_words):
    word_cloud = WordCloud(background_color='white', width=1200, height=1000, max_words=50, collocations=False, stopwords=stop_words).generate(content)
    plt.imshow(word_cloud)
    plt.axis('off')
    plt.show()


# calculate positive and negative tones
def inq_dict():
    iphone_df = pd.DataFrame()
    iphone_df['word_count'] = dtmd.sum(axis=1).values
    iphone_df['positive_inq'] = dtmd[[col for col in dtmd.columns if voc[col] in inqpos]].sum(axis=1).values / iphone_df['word_count'].values
    iphone_df['negative_inq'] = dtmd[[col for col in dtmd.columns if voc[col] in inqneg]].sum(axis=1).values / iphone_df['word_count'].values

    print(iphone_df[['positive_inq', 'negative_inq']].describe().transpose())

    return ((iphone_df['positive_inq'] - iphone_df['negative_inq']) / iphone_df['word_count'])[0]


# sentiment analysis by calculating net positive percentage
def sentiment_analysis(folder):
    content = read_files(folder)
    document_term_matrix(content)
    top_words(folder + '_top.csv')
    return inq_dict()


initialize()

# plot Google Trends
trends = pd.read_csv('google_trends.csv')
plt.plot('Week', 'Popularity', data=trends)
plt.xlabel('Week')
plt.ylabel('Iphone Search Popularity')
plt.show()

# NEWS ARTICLES
# new articles sentiment analysis
apple_sentiment = sentiment_analysis(apple_articles)
tc_sentiment = sentiment_analysis(tc_articles)
wsj_sentiment = sentiment_analysis(wsj_articles)
articles_df = pd.DataFrame([['Apple Newsroom', apple_sentiment], ['TechCrunch', tc_sentiment], ['Wall Street Journal', wsj_sentiment]], columns=['News Source', 'Sentiment Score'])

# plot sentiment scores for each news source
sns.barplot(x='News Source', y='Sentiment Score', data=articles_df)
plt.show()

# generate word clouds for each news source
articles_stops = text.ENGLISH_STOP_WORDS.union(
['8', 'X', 'x' '11', 'iphone', 'apple', 'Apple'])

apple_articles_content = read_files(apple_articles)
word_cloud_show(apple_articles_content, articles_stops)

tc_articles_content = read_files(tc_articles)
word_cloud_show(tc_articles_content, articles_stops)

wsj_articles_content = read_files(wsj_articles)
word_cloud_show(wsj_articles_content, articles_stops)

# TWEETS
# generate word cloud for all tweets
iphone_tweets_content = read_files(iphone_tweets_pre_release_folder) + '\n' + read_files(iphone_tweets_pre_release_folder)
tweets_stops = text.ENGLISH_STOP_WORDS.union(['8', 'X', 'x' '11', 'https', 'iphone', 'apple', 'Apple', 'co', 'fuck', 'Fuck', 'pussy', 'IWCNDoXYNG'])
word_cloud_show(iphone_tweets_content, tweets_stops)

# net positive sentiment analysis for each phone before and after release
net_pos_pct_iphone8_pre_release = sentiment_analysis(iphone8_tweets_pre_release_folder)
net_pos_pct_iphone8_post_release = sentiment_analysis(iphone8_tweets_post_release_folder)
net_pos_pct_iphonex_pre_release = sentiment_analysis(iphonex_tweets_pre_release_folder)
net_pos_pct_iphonex_post_release = sentiment_analysis(iphonex_tweets_post_release_folder)
net_pos_pct_iphone11_pre_release = sentiment_analysis(iphone11_tweets_pre_release_folder)
net_pos_pct_iphone11_post_release = sentiment_analysis(iphone11_tweets_post_release_folder)
net_pos_pct_iphone_pre_release = sentiment_analysis(iphone_tweets_pre_release_folder)
net_pos_pct_iphone_post_release = sentiment_analysis(iphone_tweets_post_release_folder)

# get stocks
stock = pd.read_csv('stock_info.csv')
stock['pre_post'] = stock['Date_idx'].apply(lambda x: 0 if x < 0 else 1)

# plot stock performance for each phone - subplot
iphone8 = stock[stock['Phone'] == 'Iphone8']
plt.subplot(3, 1, 1)
plt.plot(iphone8['Date_idx'], iphone8['Adj_Return'], color='blue')
plt.title('Iphone 8')

iphonex = stock[stock['Phone'] == 'Iphonex']
plt.subplot(3, 1, 2)
plt.plot(iphonex['Date_idx'], iphonex['Adj_Return'], color='red')
plt.title('Iphone x')

iphone11 = stock[stock['Phone'] == 'Iphone11']
plt.subplot(3, 1, 3)
plt.plot(iphone11['Date_idx'], iphone11['Adj_Return'], color='black')
plt.title('Iphone 11')
plt.show()

# plot stock performance for each phone - lineplot
sns.lineplot(x='Date_idx', y='Adj_Return', hue='Phone', data=stock)
plt.show()

# plot average adjusted return for each iphone before and after release
sns.barplot(x='Phone', y='Adj_Return', hue='pre_post', data=stock, ci=None, order=['Iphone8', 'Iphonex', 'Iphone11'])
plt.ylabel('Adjusted Return')
plt.show()

# map net_pos_pct to stock performance
returns = stock.groupby(['Phone', 'pre_post'])['Adj_Return'].mean().reset_index()
returns.loc[(returns['Phone'] == 'Iphone8') & (returns['pre_post'] == 0), 'net_pos_pct'] = net_pos_pct_iphone8_pre_release
returns.loc[(returns['Phone'] == 'Iphone8') & (returns['pre_post'] == 1), 'net_pos_pct'] = net_pos_pct_iphone8_post_release
returns.loc[(returns['Phone'] == 'Iphonex') & (returns['pre_post'] == 0), 'net_pos_pct'] = net_pos_pct_iphonex_pre_release
returns.loc[(returns['Phone'] == 'Iphonex') & (returns['pre_post'] == 1), 'net_pos_pct'] = net_pos_pct_iphonex_post_release
returns.loc[(returns['Phone'] == 'Iphone11') & (returns['pre_post'] == 0), 'net_pos_pct'] = net_pos_pct_iphone11_pre_release
returns.loc[(returns['Phone'] == 'Iphone11') & (returns['pre_post'] == 1), 'net_pos_pct'] = net_pos_pct_iphone11_post_release
returns.to_csv('returns_with_sentiment.csv')

# plot net positive sentiment before and after release for each phone
sns.barplot(x='Phone', y='net_pos_pct', hue='pre_post', data=returns, order=['Iphone8', 'Iphonex', 'Iphone11'])
plt.show()

# regression analysis for stock performance prediction
returns_model = pd.concat([returns, pd.get_dummies(returns['Phone'])], axis=1)
returns_model.to_csv('returns_model.csv')
form = 'Adj_Return ~ pre_post + net_pos_pct + Iphone8 + Iphonex'
model = OLS.from_formula(form, data=returns_model)
print(model.fit().summary)

{% endhighlight %}

<div class="caption">
    Sentiment Analysis Code Snippet
</div>

### Challenges

The first challenge was that I only had the basic version of the Twitter API, which allowed me to only query for limited times. Even though I created 3 twitter accounts, which gave me about 5000 tweets each, it was still far from enough. I could have improved results just by increasing the sheer volume of tweets, but I needed to spend some of the tweet counts during the testing phases of the API pull, so I had fewer remaining tries left to allocate between the iPhones. I was not able to use advanced functions, such as filtering out retweets and some key words to weed out the fluff. A lot of the tweets were not useful. If I was given the premium or enterprise version of Twitter API, I would pull more tweets for each day for more days. I would use advanced filters to filter out key words such as giveaways or ads that were considered as junk. The model I came up with was only based on 6 observations because I only had pre and post release date observations for the tweets, which were aggregated to an average sentiment score for each phone. This could be greatly improved if given more data or taking a broader approach such as increasing the number of articles, increasing the number of tweets pulled, incorporating articles published year round to see if there was a seasonal trend in sentiment for different media outlets, expanding the product line I considered to include all the generations of iPhones to track changing sentiment over time and provide more observations, or even including multiple products lines, such as MacBooks and AirPods, and not just narrowing the scope to iPhones.

The second challenge was that because of the nature of this project, I did a lot of textual analysis, but not much data analysis. The nature of the project was more descriptive than quantitative, and I had to use some descriptive context to support my theory that positive sentiment from consumers and marketing would reflect in positive or increased stock returns. I tried to incorporate some data analysis, but it was limited.

### Conclusion and Recommendations

Consumer sentiment is a strong predictor of a company’s stock performance. For iPhones, consumers and news reporters were in general more positive than negative. iPhone 11 was not as successful as iPhone 8 and iPhone X based on the smaller increase in positive sentiment after its release relative to the other two models and based on the coefficients and p-values of the regression analysis. I also noticed that for the iPhone 11, there were considerably fewer articles published from my sources related to Apple and iPhone products in general in the two weeks leading up to the release than for the same time frame prior to the iPhone 8 and iPhone X releases. Along with the observations of the lower stock returns during the period for the iPhone 11, this seems to support that there was less success with the marketing strategy and less positive sentiment associated with the release of the iPhone 11, at least in news coverage. I recommend that Apple marketing strategy and media or brand management teams make an effort to stay more engaged with general consumers via social media platforms and through media coverage such as news publishers before and after each new iPhone release, especially with technology focused publishing because tech articles tend to mention leaks and new information regarding new features in a very positive sentiment. Continuous and consistent coverage will encourage consumers to actively talk about the products, keep topics trending, create more opportunities to develop positive sentiment, and ultimately lead to better stock performance.
