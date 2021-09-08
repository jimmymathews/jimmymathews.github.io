function falling_factorial(first, last) {
    let big_first = BigInt(first)
    let big_last = BigInt(last)
    let accumulator = BigInt(1)
    for (let k = last; k <= first; k++) {
        accumulator = accumulator * BigInt(k)
    }
    return accumulator
}

function factorial(number) {
    return falling_factorial(number, 1)
}

function binom(ambient_size, subset_size) {
    smaller = Math.min(subset_size, ambient_size - subset_size)
    larger = Math.max(subset_size, ambient_size - subset_size)
    return falling_factorial(ambient_size, larger + 1) / factorial(smaller)
}

function sign(x) {
    if (x % 2 == 0) {
        return 1
    } else {
        return -1
    }
}

function compute_number_of_covers(set_sizes, ambient_size) {
    let N = ambient_size
    let n = set_sizes
    accumulator = BigInt(0)
    for (let m = Math.max(...n); m < N+1; m++) {
        product = BigInt(1)
        for (let i = 0; i < n.length; i++) {
            product *= binom(m, n[i])
        }
        accumulator += BigInt(sign(N+m)) * binom(N,m) * product
    }
    return accumulator
}

function count_all_configurations(set_sizes, ambient_size) {
    product = BigInt(1)
    for (let i = 0; i < set_sizes.length; i++) {
        product *= binom(ambient_size, set_sizes[i])
    }
    return product
}

function calculate_probability_of_multicoincidence(ambient_size, set_sizes, intersection_size) {
    reduced_sizes = []
    for (let i = 0; i < set_sizes.length; i++) {
        reduced_sizes.push(set_sizes[i] - intersection_size)
    }

    initial_choices = binom(ambient_size, intersection_size)
    reduced_ambient_size = ambient_size - intersection_size
    complementary_sizes = []
    for (let i = 0; i < reduced_sizes.length; i++) {
        complementary_sizes.push(reduced_ambient_size - reduced_sizes[i])
    }
    covers_of_remaining = compute_number_of_covers(complementary_sizes, reduced_ambient_size)
    all_configurations = count_all_configurations(set_sizes, ambient_size)
    precision = 10000000000000000
    return (Number(initial_choices * covers_of_remaining * BigInt(precision) / all_configurations) / precision)
}

function coincidencetest(incidence_statistic, frequencies, number_samples, correction_feature_set_size) {
    accumulator = 0
    for (let I = incidence_statistic; I <= Math.min(...frequencies); I++) {
        accumulator += calculate_probability_of_multicoincidence(number_samples, frequencies, I)
        if (accumulator > 0.9) {
            accumulator = 1.0
            break
        }
    }
    if ( !(correction_feature_set_size == null) ) {
        accumulator = accumulator * parseInt(binom(correction_feature_set_size, frequencies.length))
        if (accumulator > 1.0) {
            accumulator = 1.0
        }
    }
    return accumulator
}



function arrays_equal(a, b) {
    if (a.length !== b.length) return false;
    for (var i = 0; i < a.length; ++i) {
        if (a[i] !== b[i]) {
            return false;
        }
    }
    return true;
}

function compute_closure(set, data) {
    let N = set.length
    let samples = []
    for (let i = 0; i < data["samples"].length; i++) {
        accumulator = 0
        for (let j = 0; j < set.length; j++) {
            accumulator += data["samples"][i][set[j]]
        }
        if (accumulator == N) {
            samples.push(i)
        }
    }
    samples.sort()

    let M = samples.length
    let features = []
    for (let i = 0; i < data["features"].length; i++) {
        accumulator = 0
        for (let j = 0; j < samples.length; j++) {
            accumulator += data["features"][i][samples[j]]
        }
        if (accumulator == M) {
            features.push(i)
        }
    }
    features.sort()

    return {"closed set" : features, "dual set" : samples}
}

function already_have(set, sets) {
    for (I in sets) {
        other = sets[I]
        if (arrays_equal(set, other)) {
            return true
        }
    }
    return false
}

function get_all_pairs(list) {
    let results = []
    for (let i = 0; i < list.length - 1; i++) {
        for (let j = i + 1; j < list.length; j++) {
            results.push([list[i], list[j]])
        }
    }
    return results
}

function get_random_integer(min, max) {
  return Math.floor(Math.random() * (max - min + 1) ) + min;
}

function get_random_sample(list, size) {
    let sampled = []
    while (sampled.length < size) {
        sample = getRandomInteger(0, list.length - 1)
        if (sampled.includes(sample)) {
            continue
        } else {
            sampled.push(sample)
        }
    }
    return Array.from(sampled, (i) => list[i]).sort();
}

function do_pairwise_closures(closed_sets, dual_sets, computed_pairs, level_limit, data, single_addition_callback) {
    let range = Array(closed_sets.length).fill().map((x,i)=>i)
    let all_pairs = get_all_pairs(range)
    
    let a = new Set(all_pairs)
    let b = new Set(computed_pairs)
    let index_range = new Set([...a].filter(x => !b.has(x)));

    if (index_range.length == 0) {
        return
    }

    if ( !(level_limit == null) ) {
        new_pairs = get_random_sample(index_range, level_limit)
    }
    else {
        new_pairs = [...index_range]
    }

    for (I in new_pairs) {
        pair = new_pairs[I]

        index1 = pair[0]
        index2 = pair[1]

        a = new Set(closed_sets[index1]);
        b = new Set(closed_sets[index2]);
        union = new Set([...a, ...b]);
        union = [...union].sort()
        c = compute_closure(union, data)

        if ( !(c["dual set"].length == 0) ) {
            if ( !(already_have(c["closed set"], closed_sets)) ) {
                closed_sets.push(c["closed set"])
                dual_sets.push(c["dual set"])
                single_addition_callback(c)
            }
        }
        computed_pairs.push([index1, index2])
    }
}

function find_concepts(data, level_limit, max_recursion, single_addition_callback) {
    closed_sets = []
    dual_sets = []

    columns = Array(data['features'].length).fill().map((x,i)=>i)
    for (I in columns) {
        feature = columns[I]
        c = compute_closure([feature], data)
        if ( !(already_have(c["closed set"], closed_sets)) && !(c["dual set"].length == 0) ) {
            closed_sets.push(c["closed set"])
            dual_sets.push(c["dual set"])
            single_addition_callback(c)
        }
    }

    computed_pairs = []
    level = 1
    while (true) {
        previous_number_sets = closed_sets.length
        new_pairs_computed = do_pairwise_closures(closed_sets, dual_sets, computed_pairs, level_limit, data, single_addition_callback)
        new_number_sets = closed_sets.length
        if ( previous_number_sets == new_number_sets ) {
            break
        }
        if ( !(max_recursion == null) ) {
            if(level == max_recursion) {
                break
            }
        }
        level += 1
    }

    named_signatures = Array.from(closed_sets, (s) => get_named(s, data["header"]))

    return [named_signatures, dual_sets]
}

function get_named(indices, names) {
    named = []
    for (let k = 0; k < indices.length; k++) {
        named.push(names[indices[k]])
    }
    return named
}



var tsv_object = {
    data : null,
}

var signatures_object = {
    closed_sets : [],
    dual_sets : [],
    p_values : [],
}

function get_frequencies(feature_indices) {
    frequencies = []
    for (let k = 0; k < feature_indices.length; k++) {
        i = feature_indices[k]
        feature = tsv_object.data["features"][i]
        sum = feature.reduce((a, b) => a + b, 0)
        frequencies.push(sum)
    }
    return frequencies
}

function do_one_coincidence_test() {
    let number_samples = tsv_object.data["samples"].length
    let number_features = tsv_object.data["features"].length
    i = signatures_object.closed_sets.length - 1
    let incidence_statistic = dual_sets[i].length
    let frequencies = get_frequencies(closed_sets[i])
    console.log(incidence_statistic + ", " + frequencies + ", " + number_samples)
    let p = coincidencetest(incidence_statistic, frequencies, number_samples, number_features)
    console.log("pvalue: " + p)
    signatures_object.p_values.push(p)
}

function pipeline(raw_data) {
    parsed = parse_table(raw_data)
    tsv_object.data = {
        "header" : parsed[0],
        "samples" : parsed.slice(1),
        "features" : nested_list_transpose(parsed.slice(1)),
    }
    signatures_object.total_samples = tsv_object.data["samples"].length

    single_addition_callback = function(c) {
        signatures_object.closed_sets.push(get_named(c["closed set"], tsv_object.data["header"]))
        signatures_object.dual_sets.push(c["dual set"])
        do_one_coincidence_test()
        // show_signatures()
        postMessage(signatures_object)
    }

    c = find_concepts(tsv_object.data, null, null, single_addition_callback)
    postMessage('Done with concepts.')
}

function nested_list_transpose(nested_list) {
    transposed = Array(nested_list[0].length).fill(null)
    for (let j = 0; j < transposed.length; j++) {
        transposed[j] = Array(nested_list.length).fill(0)
    }

    for (let i = 0; i < nested_list.length; i++) {
        for (let j = 0; j < nested_list[0].length; j++) {
            transposed[j][i] = nested_list[i][j]
        }
    }
    return transposed
}

function parse_table(text){
    let rows = []
    let lines = text.trim().split('\n')
    rows.push(lines[0].split('\t'))
    for (let i = 1; i < lines.length; i++) {
        let row = []
        splitted = lines[i].split('\t')
        for (let j = 0; j < splitted.length; j++) {
            if ( splitted[j] == '0' || splitted[j] == '1' ) {
                row.push(parseInt(splitted[j]))
            }
            else {
                console.warn("Table data should be binary, '1' or '0'.")
            }
        }
        rows.push(row)
    }
    return rows
}

function worker_onmessage(event) {
    tsv_object = {
        data : null,
    }

    signatures_object = {
        closed_sets : [],
        dual_sets : [],
        p_values : [],
    }

    pipeline(event.data)
}

onmessage = worker_onmessage
