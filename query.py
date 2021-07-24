# Source https://github.com/kpu/kenlm/blob/master/python/example.py

import os
import kenlm

# model = kenlm.LanguageModel('news_titles.dense.binary')
model = kenlm.LanguageModel('news_titles.spare.binary')
print('\n{0}-gram model'.format(model.order))

# sentence = '^nhieu|zf he|zj luy|j khon|z luong|wf tu|wf viec|zj lam|f gia|r thuc|wj pham|zr chuc|ws nang|w'
sentence = '^ nhieu zf he zj luy j khon z luong wf tu wf viec zj lam f gia r thuc wj pham zr chuc ws nang w'
# sentence = 'nhieu he luy khon luong tu viec lam gia thuc pham chuc nang'
print("\nSent:", sentence)
print('Score', model.score(sentence))
print('Perplexity', model.perplexity(sentence))

print("\nWords:")

# Check that total full score = direct score
def score(s):
    return sum(prob for prob, _, _ in model.full_scores(s))

assert (abs(score(sentence) - model.score(sentence)) < 1e-3)

# Show scores and n-gram matches
words = ['<s>'] + sentence.split() + ['</s>']

for i, (prob, length, oov) in enumerate(model.full_scores(sentence)):
    print('{0:05f} {1}: {2}'.format(prob, length, ' '.join(words[i+2-length:i+2])))
    if oov:
        print('\t"{0}" is an OOV'.format(words[i+1]))

# Find out-of-vocabulary words
for w in words:
    if not w in model:
        print('"{0}" is an OOV'.format(w))

#Stateful query
state = kenlm.State()
state2 = kenlm.State()
#Use <s> as context.  If you don't want <s>, use model.NullContextWrite(state).
model.BeginSentenceWrite(state)
accum = 0.0
accum += model.BaseScore(state, "a", state2)
accum += model.BaseScore(state2, "sentence", state)
#score defaults to bos = True and eos = True.  Here we'll check without the end
#of sentence marker.  
assert (abs(accum - model.score("a sentence", eos = False)) < 1e-3)
accum += model.BaseScore(state, "</s>", state2)
assert (abs(accum - model.score("a sentence")) < 1e-3)
